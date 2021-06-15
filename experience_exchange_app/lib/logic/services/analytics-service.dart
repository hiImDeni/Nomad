import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

class AnalyticsService extends ChangeNotifier {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  logError(String errorMessage) async {
    await _analytics.logEvent(name: 'authentication_error', parameters: {'message': errorMessage});
  }

  logSignUp(String email) async {
    await _analytics.logEvent(name: 'sign_up', parameters: {'email': email});
  }

  logNewSignIn(String email) async {
    await _analytics.logEvent(name: 'sign_in', parameters: {'email': email});
  }
}