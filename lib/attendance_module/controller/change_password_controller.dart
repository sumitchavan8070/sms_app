import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/utils/dio/api_end_points.dart';
import 'package:school_management/utils/dio/api_request.dart';

class ChangePasswordController extends GetxController {
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final apiEndPoint = APIEndPoints.changePassword;

    final postData = {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };

    try {
      final response = await postRequest(
        apiEndPoint: apiEndPoint,
        postData: postData,
      );

      if (response.statusCode != 200) {
        throw 'API ERROR ${response.statusCode} Message ${response.statusMessage}';
      }

      /// Return clean Map
      return {
        "status": response.data['status'],
        "message": response.data['message'],
      };

    } catch (error) {
      debugPrint("---------- $apiEndPoint Error ----------");
      debugPrint("ChangePasswordController => Error: $error");

      return {
        "status": 0,
        "message": "Something went wrong",
      };
    }
  }
}
