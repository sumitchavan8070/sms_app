class APIEndPoints {
  // static const live = 'https://www.gradding.com/api/mobile-api/v1/';
  static const live = 'https://fluttertales.tech/mobileapi/v1/';
  static const local = 'http://localhost:9090/mobileapi/v1';

  // static const beta = 'https://beta-web.gradding.com/api/mobile-api/v1/';
  // static const stagging = 'https://beta-web.gradding.com/api/mobile-api/v1/';

  static const base = live;

  static const clientLogin = "auth/client-login";
  static const updateFcmToken = 'auth/update-fcm-token';
  static const getClientProfile = 'auth/get-client-profile';
  static const changePassword = 'auth/change-password';

  static const getAttendanceByUserAndDate = "attendance/get-attendance-by-user-and-date";

}
