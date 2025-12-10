import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/attendance_module/model/get_announcements_model.dart';
import 'package:school_management/utils/dio/api_end_points.dart';
import 'package:school_management/utils/dio/api_request.dart';

class GetAnnouncementsController extends GetxController with StateMixin<GetAnnouncementsModel> {
    getAnnouncements() async {
    const apiEndPoint = APIEndPoints.getAnnouncements;

    debugPrint("---------- $apiEndPoint getProfileData Start ----------");
    try {
      change(null, status: RxStatus.loading());

      final response = await getRequest(apiEndPoint: apiEndPoint);

      debugPrint("GetAnnouncementsController => getAnnouncements > Success ${response.data} ");

      final modal = GetAnnouncementsModel.fromJson(response.data);
      change(modal, status: RxStatus.success());
    } catch (error) {
      debugPrint("---------- $apiEndPoint getAnnouncements End With Error ----------");
      debugPrint("GetAnnouncementsController => getAnnouncements > Error $error ");
      change(null, status: RxStatus.error());
    } finally {
      debugPrint("---------- $apiEndPoint getAnnouncements End ----------");
    }
  }
}
