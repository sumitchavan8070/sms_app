import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_management/attendance_module/controller/get_attendance_by_user_and_date_controller.dart';
import 'package:school_management/utils/constants/app_colors.dart';
import 'package:school_management/utils/constants/asset_paths.dart';
import 'package:school_management/utils/constants/fancy_app_bar.dart';
import 'package:school_management/utils/constants/app_page.dart';

final _attendanceController = Get.put(GetAttendanceByUserAndDateController());

class ClientAttendanceView extends StatefulWidget {
  const ClientAttendanceView({super.key});

  @override
  ClientAttendanceViewState createState() => ClientAttendanceViewState();
}

class ClientAttendanceViewState extends State<ClientAttendanceView> {
  DateTime _currentMonth = DateTime.now();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _attendanceController.getAttendanceByUserAndDate(today);
  }

  // ---------- UTIL: Dates for calendar display ----------
  List<DateTime> getDisplayDates(DateTime current) {
    final firstDay = DateTime(current.year, current.month, 1);
    final lastDay = DateTime(current.year, current.month + 1, 0);

    DateTime start = firstDay;
    while (start.weekday != DateTime.sunday) {
      start = start.subtract(const Duration(days: 1));
    }

    DateTime end = lastDay;
    while (end.weekday != DateTime.saturday) {
      end = end.add(const Duration(days: 1));
    }
    end = end.add(const Duration(days: 1));

    List<DateTime> days = [];
    DateTime index = start;

    while (index.isBefore(end)) {
      days.add(index);
      index = index.add(const Duration(days: 1));
    }

    return days;
  }

  // ---------- CHECK STATUS ----------
  String getStatus(DateTime day) {
    DateTime normalized = DateTime(day.year, day.month, day.day);

    if (_attendanceController.presentDates.contains(normalized)) return "P";
    if (_attendanceController.absentDates.contains(normalized)) return "A";

    return "";
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year && now.month == date.month && now.day == date.day;
  }

  // ---------- LOAD NEW MONTH ----------
  void changeMonth(int jump) {
    if (jump == 0) {
      _currentMonth = DateTime.now();
    }
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + jump);
    });

    /// Call API for the first day of that month
    String formatted = DateFormat('yyyy-MM-dd').format(_currentMonth);
    _attendanceController.getAttendanceByUserAndDate(formatted);
  }

  @override
  Widget build(BuildContext context) {
    final days = getDisplayDates(_currentMonth);
    final monthName = DateFormat('MMMM yyyy').format(_currentMonth);

    return AppPageView(
      body: Column(
        children: [
          const FancyTopBar(
            title: "Attendance",
            showLogo: false,
            backButton: true,
            showActions: false,
          ),

          Expanded(
            child: _attendanceController.obx((state) {
              if (_attendanceController.status.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    /// MONTH HEADER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            monthName,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => changeMonth(-1),
                                child: Icon(Icons.arrow_back_ios_new, size: 18),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () => changeMonth(1),
                                child: Icon(Icons.arrow_forward_ios, size: 18),
                              ),
                              const SizedBox(width: 14),

                              /// TODAY BUTTON
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  minimumSize: const Size(60, 36),
                                ),
                                onPressed: () {
                                  changeMonth(0);
                                  selectedDate = DateTime.now();
                                },
                                child: Text("Today", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// WEEKDAY ROW
                    Row(
                      children: List.generate(7, (index) {
                        List<String> weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
                        return Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            color: AppColors.primaryColor.withOpacity(0.5),
                            child: Text(
                              weekdays[index],
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    /// CALENDAR GRID
                    GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisExtent: 80,
                      ),
                      itemCount: days.length,
                      itemBuilder: (_, index) {
                        final day = days[index];
                        final status = getStatus(day);

                        bool selected =
                            selectedDate != null &&
                            selectedDate!.day == day.day &&
                            selectedDate!.month == day.month &&
                            selectedDate!.year == day.year;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDate = day;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            color: isToday(day)
                                ? AppColors.primaryColor.withOpacity(0.25)
                                : selected
                                ? AppColors.primaryColor.withOpacity(0.4)
                                : Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${day.day}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: status == 'P'
                                        ? AppColors.black
                                        : status == 'A'
                                        ? Colors.red
                                        : day.month != _currentMonth.month
                                        ? Colors.grey
                                        : day.weekday == DateTime.sunday
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                                if (status.isNotEmpty)
                                  Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: status == 'P' ? AppColors.primaryColor : Colors.red,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),

      floatLocation: FloatingActionButtonLocation.endFloat,

      floatingActionWidget: selectedDate != null && !isToday(selectedDate!)
          ? FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              onPressed: () {
                selectedDate = DateTime.now();
                changeMonth(0);
              },
              child: Text(
                DateFormat('dd').format(DateTime.now()),
                style: const TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }
}
