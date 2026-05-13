import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:my_panic/core/theme/app_theme.dart';
import 'package:my_panic/features/keychain/data/keychain_bluetooth_repository.dart';
import 'package:my_panic/features/keychain/data/keychain_device_repository.dart';

/// Single-screen pairing flow:
///   1. Request BLE + location permissions.
///   2. Scan 10s for advertising MyPanic devices.
///   3. User picks one, enters a display name + WiFi creds.
///   4. App calls server pair, then BLE-writes the secret + WiFi creds.
///
/// The WiFi password is collected interactively because Android does not
/// expose stored WiFi passwords to non-system apps. A future iteration can
/// pre-fill the SSID via the network_info_plus plugin.
class KeychainPairingScreen extends ConsumerStatefulWidget {
  const KeychainPairingScreen({super.key});

  @override
  ConsumerState<KeychainPairingScreen> createState() =>
      _KeychainPairingScreenState();
}

class _KeychainPairingScreenState extends ConsumerState<KeychainPairingScreen> {
  bool _scanning = false;
  bool _pairing = false;
  String? _error;
  final List<ScanResult> _results = [];
  StreamSubscription<List<ScanResult>>? _scanSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScan());
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    final repo = ref.read(keychainBluetoothRepositoryProvider);
    repo.stopScan();
    super.dispose();
  }

  Future<void> _startScan() async {
    setState(() {
      _scanning = true;
      _error = null;
      _results.clear();
    });

    final granted = await _ensurePermissions();
    if (!granted) {
      setState(() {
        _error = 'Bluetooth and location permissions are required. '
            'Open Settings → Apps → MyPanic to grant them.';
        _scanning = false;
      });
      return;
    }

    final repo = ref.read(keychainBluetoothRepositoryProvider);

    try {
      await _scanSub?.cancel();
      _scanSub = repo.scan().listen((batch) {
        if (!mounted) return;
        setState(() {
          _results
            ..clear()
            ..addAll(batch);
        });
      });
      // Auto-stop the spinner after the 10s scan window.
      await Future<void>.delayed(const Duration(seconds: 11));
      if (mounted) setState(() => _scanning = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Scan failed: $e';
          _scanning = false;
        });
      }
    }
  }

  Future<bool> _ensurePermissions() async {
    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();
    return statuses.values.every((s) => s.isGranted);
  }

  Future<void> _pairDevice(ScanResult result) async {
    if (_pairing) return;

    final initialName = result.device.platformName.isNotEmpty
        ? result.device.platformName
        : 'My keychain';
    final displayName = await _promptForName(initialName);
    if (displayName == null) return;

    final wifi = await _promptForWifi();
    if (wifi == null) return;

    setState(() {
      _pairing = true;
      _error = null;
    });

    final bleRepo = ref.read(keychainBluetoothRepositoryProvider);
    final deviceRepo = ref.read(keychainDeviceRepositoryProvider);

    KeychainCharacteristics? chars;
    try {
      await bleRepo.stopScan();
      chars = await bleRepo.connect(result.device);
      final hardwareId = await bleRepo.readHardwareId(chars);

      final paired = await deviceRepo.pairDevice(
        hardwareId: hardwareId,
        displayName: displayName,
      );

      await bleRepo.writePairData(
        chars,
        deviceSecret: paired.deviceSecret,
        wifiSsid: wifi.$1,
        wifiPass: wifi.$2,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paired "$displayName"')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Pairing failed: $e';
        _pairing = false;
      });
    } finally {
      // Always release the BLE connection so the firmware can re-advertise
      // for the next pair or the background listener.
      try {
        await chars?.device.disconnect();
      } catch (_) {
        // already disconnected
      }
      if (mounted && _pairing) {
        setState(() => _pairing = false);
      }
    }
  }

  Future<String?> _promptForName(String initial) async {
    final controller = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Name this keychain'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'My keychain'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final trimmed = controller.text.trim();
              if (trimmed.isEmpty) return;
              Navigator.pop(ctx, trimmed);
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  Future<(String, String)?> _promptForWifi() async {
    final ssidCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    return showDialog<(String, String)>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('WiFi for the keychain'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'The keychain uses WiFi as a backup if it cannot reach your '
              'phone. Enter the WiFi the keychain will use.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ssidCtrl,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'SSID'),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final ssid = ssidCtrl.text.trim();
              final pass = passCtrl.text;
              if (ssid.isEmpty || pass.isEmpty) return;
              Navigator.pop(ctx, (ssid, pass));
            },
            child: const Text('Pair'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBrand,
      appBar: AppBar(
        title: const Text('Pair Panic Keychain'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          if (_scanning) const LinearProgressIndicator(),
          if (_pairing)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Pairing…'),
                ],
              ),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _error!,
                style: const TextStyle(color: AppTheme.brandPink),
              ),
            ),
          Expanded(
            child: _results.isEmpty && !_scanning
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No MyPanic keychains found nearby.\n\n'
                        'Make sure the keychain is in pairing mode '
                        '(power-cycle it; it advertises for 60s on boot).',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: _results.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final r = _results[i];
                      final label = r.device.platformName.isNotEmpty
                          ? r.device.platformName
                          : r.device.remoteId.toString();
                      return ListTile(
                        leading: const Icon(Icons.bluetooth),
                        title: Text(label),
                        subtitle: Text('RSSI ${r.rssi} dBm'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _pairing ? null : () => _pairDevice(r),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (_scanning || _pairing) ? null : _startScan,
        icon: const Icon(Icons.refresh),
        label: const Text('Rescan'),
      ),
    );
  }
}
