import 'dart:developer';
import 'package:flutter/material.dart';

class RouterLogger extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('Did Push: ${route.settings.name}', name: 'Navigation');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('Did Pop: ${route.settings.name}', name: 'Navigation');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    log('Did Replace: ${newRoute?.settings.name}', name: 'Navigation');
  }
}
