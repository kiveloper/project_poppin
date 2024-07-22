
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsHelper {
  static final AnalyticsHelper _instance = AnalyticsHelper._internal();

  factory AnalyticsHelper() {
    return _instance;
  }

  AnalyticsHelper._internal();

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  void logEvent(String eventName, Map<String, Object> parameters) {
    analytics.logEvent(name: eventName, parameters: parameters);
  }
}