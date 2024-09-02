import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsServices {
  late FirebaseAnalytics analytics;

  /// Constructor for Analytics
  ///
  /// It initiates a Firebase analytics instance.
  /// Prerequisites: Firebase.initializeApp() must have been called before this
  AnalyticsServices() {
    analytics = FirebaseAnalytics.instance;
  }

  /// Logs the initial event in analytics.
  ///
  /// This function can be used to specify when an application was opened.
  void startApp()  {
    analytics.logAppOpen();
  }

  /// Sets a user name and id for analytics
  ///
  /// Firebase analytics uses Google Play services. It automatically gets some
  /// information from there. This function is to specifically set the user id
  /// or name. Useful if we ever force login on the app.
  ///
  /// @param userId The id of the user
  /// @param userName The name of the user
  void setUser(String userId, String userName) {
    analytics.setUserId(id: userId);
    analytics.setUserProperty(name: "name", value: userName);
  }

  /// Logs a screen view event in Firebase analytics
  ///
  /// Firebase analytics by default logs the class name of the UIViewController
  /// or Activity that is currently in focus.
  /// When a screen transition occurs, analytics logs a screen_view event
  /// If you want to manually log a screen view event, you can use this function
  ///
  /// @param screenClass The class of the Activity or screen
  /// @param screenName The name of the screen
  void logScreen(String screenClass, String screenName) {
    analytics.logScreenView(screenClass: screenClass, screenName: screenName);

  }

  Future<void> logEvent(String eventName, Map<String, dynamic> parameters) async {
    await analytics.logEvent(
        name: eventName,
        parameters: parameters);

  }


  /// Logs an event for viewing search results
  ///
  /// @param searchTerm The search term for the results
  void logViewSearchResults(String searchTerm) {
    analytics.logViewSearchResults(searchTerm: searchTerm);
  }

  /// Logs an event for viewing a property
  ///
  /// @param propertyId The id of the property
  void logViewProperty(String propertyId) {
    analytics.logEvent(
        name: 'view_property',
        parameters: {
          'propertyId': propertyId,
        }
    );
  }
}