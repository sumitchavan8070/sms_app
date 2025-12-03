import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_management/attendance_module/controller/get_students_by_class_controller.dart';
import 'package:school_management/attendance_module/model/get_students_by_class_model.dart';
import 'package:school_management/utils/constants/app_box_decoration.dart';
import 'package:school_management/utils/constants/app_colors.dart';
import 'package:school_management/utils/constants/app_page.dart';
import 'package:school_management/utils/constants/fancy_app_bar.dart';

final _controller = Get.put(GetStudentsByClassController());

class AttendanceManagementScreen extends StatefulWidget {
  const AttendanceManagementScreen({super.key});

  @override
  State<AttendanceManagementScreen> createState() => _AttendanceManagementScreenState();
}

class _AttendanceManagementScreenState extends State<AttendanceManagementScreen> {
  DateTime selectedDate = DateTime.now();
  bool allSelected = false;

  @override
  void initState() {
    super.initState();
    _fetchData(selectedDate);
  }

  void _fetchData(DateTime date) {
    final formatted = DateFormat("yyyy-MM-dd").format(date);
    _controller.getStudentsByClass(formatted);
  }

  @override
  Widget build(BuildContext context) {
    return AppPageView(
      extendBody: true,
      body: Column(
        children: [
          const FancyTopBar(
            backButton: true,
            title: "Manage Class Students",
            showLogo: false,
            showActions: false,
          ),

          // const SizedBox(height: 20),

          /// 👇 FIX — Expanded makes list scrollable
          Expanded(
            child: _controller.obx((state) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: state?.result?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = state!.result![index];

                  return StudentAttendanceTile(
                    studentId: item.studentId?.toInt() ?? 0,
                    className: item.className ?? "",
                    rollNumber: item.rollNumber?.toInt() ?? 0,
                    studentName: item.studentName ?? "",
                    gender: item.gender ?? "",
                    dob: item.dob ?? "",
                    address: item.address ?? "",
                    attendanceStatus: item.attendanceStatus ?? "",
                    attendanceRemarks: item.attendanceRemarks ?? "",
                    attendanceDate: item.attendanceDate ?? "",
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class StudentAttendanceTile extends StatelessWidget {
  final int studentId;
  final String className;
  final int rollNumber;
  final String studentName;
  final String gender;
  final String dob;
  final String address;
  final String attendanceStatus;
  final String attendanceRemarks;
  final String attendanceDate;

  const StudentAttendanceTile({
    super.key,
    required this.studentId,
    required this.className,
    required this.rollNumber,
    required this.studentName,
    required this.gender,
    required this.dob,
    required this.address,
    required this.attendanceStatus,
    required this.attendanceRemarks,
    required this.attendanceDate,
  });

  Color getStatusColor() {
    switch (attendanceStatus.toLowerCase()) {
      case "present":
        return Colors.green;
      case "absent":
        return Colors.red;
      case "on leave":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppBoxDecoration.getBorderBoxDecoration(
        showShadow: true,
        borderColor: AppColors.iron,
      ),
      padding: EdgeInsets.symmetric(vertical: 12),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header - Name + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  studentName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusColor().withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    attendanceStatus.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: getStatusColor(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// Roll No & Class
            Text(
              "Roll No: $rollNumber • $className",
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),

            /// Gender & DOB
            Text(
              "Gender: $gender • DOB: ${dob.split('T')[0]}",
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),

            /// Address
            Text("Address: $address", style: const TextStyle(fontSize: 13, color: Colors.grey)),

            const SizedBox(height: 10),

            /// Date
            Text(
              "Attendance Date: $attendanceDate",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),

            /// Remarks (optional)
            if (attendanceRemarks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  "Remarks: $attendanceRemarks",
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
