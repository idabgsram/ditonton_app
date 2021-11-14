import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class FirebaseAnalyticsUtils {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future logEvent(
      {required String eventName, Map<String, dynamic>? data}) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: data,
    );
  }
}
