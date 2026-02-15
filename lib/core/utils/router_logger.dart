import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RouterLogger extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('[Navigation] Did Push: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('[Navigation] Did Pop: ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    debugPrint('[Navigation] Did Replace: ${newRoute?.settings.name}');
  }
}
