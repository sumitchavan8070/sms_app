import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/attendance_module/model/get_students_by_class_model.dart';
import 'package:school_management/authentication_module/controller/client_profile_controller.dart';
import 'package:school_management/utils/dio/api_request.dart';

import '../../constants.dart';

final _clientProfileController = Get.put(ClientProfileController());

class GetStudentsByClassController extends GetxController with StateMixin<GetStudentsByClassModel> {
  final schoolId = _clientProfileController.state?.profile?.user?.schoolId ?? "";


  getStudentsByClass(String date) async {
    logger.e("schoolId $schoolId");

    final apiEndPoint = "class/get-students-by-class?schoolId=$schoolId&date=$date";

    change(null, status: RxStatus.loading());
    debugPrint("---------- $apiEndPoint DashBoardController Start --------- -");

    // final formData = {"countryId": countryId, "city": city};

    try {
      final response = await getRequest(apiEndPoint: apiEndPoint);

      final modal = GetStudentsByClassModel.fromJson(response.data);

      change(modal, status: RxStatus.success());
      debugPrint("GetStudentsByClassController =>  accommodationDashboard > Success  \n ${response.data}");
    } catch (error) {
      debugPrint(" GetStudentsByClassController =>  accommodationDashboard > Error $error ");
      change(null, status: RxStatus.error(error.toString()));

    } finally {
      debugPrint("---------- $apiEndPoint  accommodationDashboard End ----------");
    }
  }


  void updateStudent(int index, GetStudentsByClassModel student) {
    final current = state;
    if (current == null) return;

    // current.result![index] = student;

    change(current, status: RxStatus.success());
  }

  void refreshStats() {
    final current = state;
    if (current == null) return;

    int present = current.result!.where((e) => e.attendanceStatus == "present").length;
    int absent = current.result!.where((e) => e.attendanceStatus == "absent").length;

    current.presentStudents = present;
    current.absentStudents = absent;

    change(current, status: RxStatus.success());
  }
}
