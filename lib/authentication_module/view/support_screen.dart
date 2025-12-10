import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/utils/components/core_messenger.dart';
import 'package:school_management/utils/constants/app_box_decoration.dart';
import 'package:school_management/utils/constants/app_page.dart';
import 'package:school_management/utils/constants/fancy_app_bar.dart';
import 'package:school_management/utils/navigation/navigator.dart';

import '../controller/submit_client_query_controller.dart';

final _supportController = Get.put(SubmitClientQueryController());

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController subjectCtrl = TextEditingController();
  final TextEditingController queryCtrl = TextEditingController();

  String priority = "Medium";
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AppPageView(
      body: Column(
        children: [
          const FancyTopBar(
            backButton: true,
            title: "Support",
            showLogo: false,
            showActions: false,
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    decoration: AppBoxDecoration.getBoxDecoration(
                      showShadow: true,
                      borderRadius: 16,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            buildInput(
                              label: "Email *",
                              hint: "name@school.edu",
                              controller: emailCtrl,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Email is required";
                                }
                                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                                  return "Enter valid email";
                                }
                                return null;
                              },
                            ),

                            buildInput(
                              label: "Phone",
                              hint: "+91 90000 00000",
                              controller: phoneCtrl,
                            ),

                            buildInput(
                              label: "Subject *",
                              hint: "Brief summary",
                              controller: subjectCtrl,
                              validator: (value) {
                                if (value!.isEmpty) return "Subject is required";
                                return null;
                              },
                            ),

                            // Priority Dropdown
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Priority",
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              value: priority,
                              items: [
                                "Low",
                                "Medium",
                                "High",
                                "Urgent",
                              ].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                              onChanged: (val) => setState(() => priority = val!),
                            ),

                            const SizedBox(height: 16),

                            // Query
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: const TextSpan(
                                  text: "Query / Description ",
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: "*",
                                      style: TextStyle(color: Colors.red, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: queryCtrl,
                              maxLines: 6,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: "Describe your issue...",
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) return "Query is required";
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: isSubmitting ? null : submitForm,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            isSubmitting ? "Submitting..." : "Submit",
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  // ------------------------------
  //  REUSABLE INPUT FIELD
  // ------------------------------
  Widget buildInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label.replaceAll("*", ""),
              style: const TextStyle(color: Colors.black),
              children: [
                if (label.contains("*"))
                  const TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------
  //  SUBMIT FORM (DATE REMOVED)
  // ------------------------------
  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    await Future.delayed(const Duration(milliseconds: 600));

    final isSuccess = await _supportController.submitClientQuery(
      phoneCtrl.text,
      priority,
      email: emailCtrl.text,
      subject: subjectCtrl.text,
      query: queryCtrl.text,
    );

    if(!isSuccess){
      coreMessenger("Try again late!", messageType: CoreScaffoldMessengerType.error);
      MyNavigator.pop();

      return;
    }

    if (isSuccess) {
      coreMessenger("Your Req Has been updated!", messageType: CoreScaffoldMessengerType.success);
      MyNavigator.pop();

      // Clear fields
      emailCtrl.clear();
      phoneCtrl.clear();
      subjectCtrl.clear();
      queryCtrl.clear();
      priority = "Medium";
    }

    setState(() => isSubmitting = false);
  }

  @override
  void dispose() {
    // TODO: implement dispose

    /// Reset fields
    emailCtrl.clear();
    phoneCtrl.clear();
    subjectCtrl.clear();
    queryCtrl.clear();
    priority = "Medium";
    super.dispose();
  }
}
