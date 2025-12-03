import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:school_management/utils/constants/app_page.dart';
import 'package:school_management/utils/constants/app_colors.dart';
import 'package:school_management/utils/constants/fancy_app_bar.dart';
import 'package:school_management/utils/components/core_messenger.dart';
import 'package:school_management/utils/constants/app_box_decoration.dart';
import 'package:school_management/attendance_module/controller/change_password_controller.dart';

final _changePasswordController = Get.put(ChangePasswordController());

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isSubmitting = false;

  Future<void> handleSubmit() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      coreMessenger(
        "New passwords do not match",
        messageType: CoreScaffoldMessengerType.error,
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final res = await _changePasswordController.changePassword(
        currentPassword: currentPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
      );

      final int status = res['status'] ?? 0;
      final String message = res['message'] ?? "Something went wrong";

      if (status == 1) {
        // SUCCESS
        coreMessenger(
          message,
          messageType: CoreScaffoldMessengerType.success,
        );

        // clear fields
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else {
        // FAILURE
        coreMessenger(
          message,
          messageType: CoreScaffoldMessengerType.error,
        );
      }
    } catch (e) {
      coreMessenger(
        "An error occurred: $e",
        messageType: CoreScaffoldMessengerType.error,
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return AppPageView(
      body: Column(
        children: [
          const FancyTopBar(
            showLogo: false,
            showActions: false,
            backButton: true,
            title: "Change Password",
          ),

          // SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  // Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Change Password",
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Update your account password. Make sure it is unique and secure.",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 20),
            
                  // Card UI
                  Container(
                    decoration: AppBoxDecoration.getBorderBoxDecoration(
                      showShadow: true,
                      borderColor: AppColors.iron,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CURRENT PASSWORD
                          const Text("Current Password"),
                          const SizedBox(height: 6),
                          TextField(
                            controller: currentPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Enter current password",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(height: 16),
            
                          // NEW PASSWORD
                          const Text("New Password"),
                          const SizedBox(height: 6),
                          TextField(
                            controller: newPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Enter new password",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Use at least 8 characters, including a number and symbol.",
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
            
                          const SizedBox(height: 16),
            
                          // CONFIRM PASSWORD
                          const Text("Confirm New Password"),
                          const SizedBox(height: 6),
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Confirm new password",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(height: 24),
            
                          // SUBMIT BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isSubmitting ? null : handleSubmit,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: isSubmitting
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text("Update Password"),
                            ),
                          ),
            
                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

