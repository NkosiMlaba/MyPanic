/// Panic button widget.
library;

///
/// Large, accessible button with pulse animation.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_panic/core/theme/app_theme.dart';
import 'package:my_panic/features/panic/presentation/providers/panic_notifier.dart';

/// Animated panic button widget.
class PanicButtonWidget extends ConsumerStatefulWidget {
  const PanicButtonWidget({super.key});

  @override
  ConsumerState<PanicButtonWidget> createState() => _PanicButtonWidgetState();
}

class _PanicButtonWidgetState extends ConsumerState<PanicButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onPanicPressed() {
    final hapticService = ref.read(hapticServiceProvider);
    hapticService.buttonPressFeedback();

    ref.read(panicNotifierProvider.notifier).triggerPanic();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonSize = size.width * 0.55;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _pulseAnimation.value, child: child);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow
          Container(
            width: buttonSize + 40,
            height: buttonSize + 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryRed.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          // Main button
          GestureDetector(
            onTap: _onPanicPressed,
            child: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [AppTheme.primaryRed, AppTheme.darkRed],
                  center: Alignment(-0.2, -0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.darkRed.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: AppTheme.primaryRed.withValues(alpha: 0.8),
                  width: 3,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_rounded, size: 64, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      'PANIC',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
