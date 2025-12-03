// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:school_management/attendance_module/model/get_attendance_by_user_and_date_model.dart';
// import 'package:school_management/constants.dart';
// import 'package:school_management/utils/dio/api_end_points.dart';
// import 'package:school_management/utils/dio/api_request.dart';
//
// String buildUrl(String path, {Map<String, dynamic>? query}) {
//   final uri = Uri.parse(
//     APIEndPoints.base + path,
//   ).replace(queryParameters: query?.map((key, value) => MapEntry(key, value?.toString())));
//   return uri.toString();
// }
//
// class GetAttendanceByUserAndDateController extends GetxController
//     with StateMixin<GetAttendanceByUserAndDateModel> {
//   getAttendanceByUserAndDate(String? date) async {
//     final apiEndPoint = APIEndPoints.getAttendanceByUserAndDate;
//
//     final url = buildUrl(APIEndPoints.getAttendanceByUserAndDate, query: {"date": date});
//
//     try {
//       final response = await getRequest(apiEndPoint: url);
//       if (response.statusCode != 200) {
//         throw 'API ERROR ${response.statusCode} Message ${response.statusMessage}';
//       }
//
//       final modal = GetAttendanceByUserAndDateModel.fromJson(response.data);
//       logger.f("result ${response.data}");
//       change(modal, status: RxStatus.success());
//     } catch (error) {
//       debugPrint("---------- $apiEndPoint clientLogin Error ----------");
//       debugPrint("GetAttendanceByUserAndDateController => clientLogin > Error: $error");
//
//       change(null, status: RxStatus.error());
//     } finally {
//       debugPrint("---------- $apiEndPoint clientLogin End ----------");
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/attendance_module/model/get_attendance_by_user_and_date_model.dart';
import 'package:school_management/constants.dart';
import 'package:school_management/utils/dio/api_end_points.dart';
import 'package:school_management/utils/dio/api_request.dart';

class GetAttendanceByUserAndDateController extends GetxController
    with StateMixin<GetAttendanceByUserAndDateModel> {
  /// FINAL LISTS FOR CALENDAR
  RxList<DateTime> presentDates = <DateTime>[].obs;
  RxList<DateTime> absentDates = <DateTime>[].obs;

  getAttendanceByUserAndDate(String? date) async {
    final apiEndPoint = APIEndPoints.getAttendanceByUserAndDate;

    final url = addQueryParaToRequest(apiEndPoint, query: {"date": date});

    try {
      final response = await getRequest(apiEndPoint: url);

      if (response.statusCode != 200) {
        throw 'API ERROR ${response.statusCode} Message ${response.statusMessage}';
      }

      /// Parse JSON
      final model = GetAttendanceByUserAndDateModel.fromJson(response.data);

      /// Clear previous month data
      presentDates.clear();
      absentDates.clear();

      /// Process Attendance Dates
      if (model.data != null) {
        for (var item in model.data!) {
          if (item.date == null) continue;

          /// Convert ISO string -> DateTime
          DateTime parsed = DateTime.parse(item.date!);

          /// Normalize (remove time)
          DateTime normalized = DateTime(parsed.year, parsed.month, parsed.day);

          if (item.status == "present") {
            presentDates.add(normalized);
          } else if (item.status == "absent") {
            absentDates.add(normalized);
          }
        }
      }

      logger.f("Present Dates = $presentDates");
      logger.f("Absent Dates  = $absentDates");

      change(model, status: RxStatus.success());
    } catch (error) {
      debugPrint("---------- $apiEndPoint Error ----------");
      debugPrint("GetAttendanceByUserAndDateController => Error: $error");

      change(null, status: RxStatus.error());
    } finally {
      debugPrint("---------- $apiEndPoint End ----------");
    }
  }
}
