import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

class TrackingRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    print(route.settings.name);
    FirebaseAnalytics.instance.logScreenView(
      screenName: route.settings.name,
    );
    super.didPush(route, previousRoute);
  }
}
