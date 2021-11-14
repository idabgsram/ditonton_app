import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsUtils {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future logEvent(
      {required String eventName, Map<String, dynamic>? data}) async {
    await analytics.logEvent(
      name: eventName,
      parameters: data,
    );
  }
}
