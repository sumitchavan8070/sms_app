import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:school_management/utils/components/custom_tab_bar.dart';
import 'package:school_management/utils/constants/app_box_decoration.dart';
import 'package:school_management/utils/constants/app_colors.dart';
import 'package:school_management/utils/constants/app_page.dart';
import 'package:school_management/utils/constants/fancy_app_bar.dart';

class LeaveManagementScreen extends StatefulWidget {
  const LeaveManagementScreen({super.key});

  @override
  State<LeaveManagementScreen> createState() => _LeaveManagementScreenState();
}

class _LeaveManagementScreenState extends State<LeaveManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  final _tabList = ["Apply", "Pending", "History"];

  @override
  Widget build(BuildContext context) {
    return AppPageView(
      body: Column(
        children: [
          const FancyTopBar(
            showLogo: false,
            showActions: false,
            backButton: true,
            title: "Manage Leave",
          ),

          SizedBox(height: 20),

          // Text("data"),
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: CustomTabBar(
              tabController: tabController,
              horizontalPadding: 0,
              height: 94,
              hasInnerShadow: true,
              // tabAlignment: TabAlignment.start,
              tabList: _tabList,
              // isScrollable: true,
              showBorder: true,
              fillColor: Colors.white,
              borderColor: const Color(0xFFEAEAEA),
              borderRadius: 10,
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [ApplyLeavePage(), PendingLeavePage(), LeaveHistoryPage()],
            ),
          ),
        ],
      ),
    );
  }
}

class ApplyLeavePage extends StatefulWidget {
  const ApplyLeavePage({super.key});

  @override
  State<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  final List<String> leaveTypes = ["Sick Leave", "Casual Leave", "Paid Leave", "Emergency Leave"];

  String? selectedLeaveType;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TextEditingController reasonController = TextEditingController();
  File? medicalFile;

  Future<void> pickDate(bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      medicalFile = File(result.files.single.path!);
      setState(() {});
    }
  }

  void submitLeave() {
    if (selectedLeaveType == null || reasonController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Fill all required fields")));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Leave Submitted Successfully")));

    // TODO: CALL API HERE
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: AppBoxDecoration.getBoxDecoration(showShadow: true, borderRadius: 16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Apply for Leave",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField(
                    value: selectedLeaveType,
                    decoration: const InputDecoration(
                      labelText: "Leave Type",
                      border: OutlineInputBorder(),
                    ),
                    items: leaveTypes
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() {
                      selectedLeaveType = val;
                    }),
                  ),

                  const SizedBox(height: 20),

                  InkWell(
                    onTap: () => pickDate(true),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Start Date",
                        border: OutlineInputBorder(),
                      ),
                      child: Text(DateFormat("MMM d, yyyy").format(startDate)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  InkWell(
                    onTap: () => pickDate(false),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "End Date",
                        border: OutlineInputBorder(),
                      ),
                      child: Text(DateFormat("MMM d, yyyy").format(endDate)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: reasonController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Reason",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  medicalFile == null
                      ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: submitLeave,
                            child: const Text("Upload Medical Certificate"),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Certificate Uploaded",
                              style: TextStyle(color: Colors.green),
                            ),
                            IconButton(
                              onPressed: () => setState(() {
                                medicalFile = null;
                              }),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submitLeave,
                      child: const Text("Submit Application"),
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

class PendingLeavePage extends StatelessWidget {
  const PendingLeavePage({super.key});

  final List<Map<String, String>> pendingLeaves = const [
    {
      "name": "Sumit Chavan",
      "type": "Sick Leave",
      "dates": "Dec 4 - Dec 6",
      "reason": "High fever",
    },
    {
      "name": "Amit Patil",
      "type": "Casual Leave",
      "dates": "Nov 20 - Nov 21",
      "reason": "Family function",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pendingLeaves.length,
      itemBuilder: (context, index) {
        final item = pendingLeaves[index];
        return Container(
            decoration: AppBoxDecoration.getBorderBoxDecoration(showShadow: true,borderColor: AppColors.iron),
            padding: EdgeInsets.symmetric(vertical: 12),
            margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.pending_actions),
            title: Text(item["name"]!),
            subtitle: Text("${item["type"]}\n${item["dates"]}\nReason: ${item["reason"]}"),
            isThreeLine: true,
            trailing: TextButton(onPressed: () {}, child: const Text("Withdraw")),
          ),
        );
      },
    );
  }
}

class LeaveHistoryPage extends StatelessWidget {
  const LeaveHistoryPage({super.key});

  final List<Map<String, String>> history = const [
    {
      "type": "Sick Leave",
      "dates": "Jan 10 - Jan 12",
      "status": "approved",
      "approvedBy": "Principal",
      "reason": "Cold & Cough",
    },
    {
      "type": "Casual Leave",
      "dates": "Feb 3 - Feb 4",
      "status": "rejected",
      "approvedBy": "N/A",
      "reason": "Personal reasons",
    },
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return Container(
          decoration: AppBoxDecoration.getBorderBoxDecoration(showShadow: true,borderColor: AppColors.iron),
          padding: EdgeInsets.symmetric(vertical: 12),
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(Icons.history, color: getStatusColor(item["status"]!)),
            title: Text(item["type"]!),
            subtitle: Text(
              "Dates: ${item["dates"]}\nStatus: ${item["status"]}\nReason: ${item["reason"]}",
            ),
            trailing: Text(item["approvedBy"]!),
          ),
        );
      },
    );
  }
}
