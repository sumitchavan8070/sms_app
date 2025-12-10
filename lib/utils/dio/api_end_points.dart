class APIEndPoints {
  // static const live = 'https://www.gradding.com/api/mobile-api/v1/';
  static const live = 'https://fluttertales.tech/mobileapi/v1/';
  // static const local = 'http://192.168.43.65:9090/mobileapi/v1/'; // sumit api
  static const local = 'http://192.168.43.65:9090/mobileapi/v1/';

  // static const beta = 'https://beta-web.gradding.com/api/mobile-api/v1/';
  // static const stagging = 'https://beta-web.gradding.com/api/mobile-api/v1/';

  static const base = local;

  static const clientLogin = "auth/client-login";
  static const updateFcmToken = 'auth/update-fcm-token';
  static const getClientProfile = 'auth/get-client-profile';
  static const changePassword = 'auth/change-password';

  static const getAnnouncements = 'announcements/get-announcements';

  static const getAttendanceByUserAndDate = "attendance/get-attendance-by-user-and-date";

  // http://localhost:9090/mobileapi/v1/exams/mcq/1
  static const getExam = "exams/mcq/1";
  static const sendClientQuery = "email/send/clientquery";
}
