import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management/authentication_module/controller/client_profile_controller.dart';
import 'package:school_management/constants.dart';
import 'package:school_management/utils/common_model.dart';
import 'package:school_management/utils/components/core_messenger.dart';
import 'package:school_management/utils/constants/app_box_decoration.dart';
import 'package:school_management/utils/constants/app_colors.dart';

import 'package:school_management/utils/constants/app_page.dart';
import 'package:school_management/utils/constants/asset_paths.dart';
import 'package:school_management/utils/constants/fancy_app_bar.dart';
import 'package:school_management/utils/navigation/go_paths.dart';
import 'package:school_management/utils/navigation/navigator.dart';
import 'package:school_management/utils/services/fcm_notification_service.dart';

final _profileController = Get.put(ClientProfileController());

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // _profileController.getClientProfile();
      FCMNotificationService().updateFCMToken();
      _profileController.getClientProfile();
    });

    super.initState();
  }

  final manageList = [
    KeyValuePair(key: "Exams", value: AssetPaths.examPNG, path: GoPaths.attendanceManagement),
    KeyValuePair(
      key: "Manage Attendance",
      value: AssetPaths.managementGIF,
      path: GoPaths.attendanceManagement,
    ),
    KeyValuePair(
      key: "Time Table",
      value: AssetPaths.timeTablePNG,
      path: GoPaths.attendanceManagement,
    ),
    KeyValuePair(key: "Attendance", value: AssetPaths.correctPNG, path: GoPaths.userAttendanceView),
    KeyValuePair(
      key: "Assignments",
      value: AssetPaths.assignmentsGIF,
      path: GoPaths.userAttendanceView,
    ),
    KeyValuePair(key: "Fess", value: AssetPaths.paymentsPNG, path: GoPaths.razorPayPayment),
    KeyValuePair(key: "Result", value: AssetPaths.resultPNG, path: GoPaths.userAttendanceView),
    KeyValuePair(key: "Group Chat", value: AssetPaths.groupChatGIF, path: GoPaths.groupChat),
    KeyValuePair(key: "Apply", value: AssetPaths.idCardPNG, path: GoPaths.razorPayPayment),
    KeyValuePair(key: "Leave", value: AssetPaths.campFirePNG, path: GoPaths.leaveManagement),
  ];

  @override
  Widget build(BuildContext context) {
    return AppPageView(
      extendBody: true,
      topSafeArea: false,
      showBottomNavigation: true,
      showDrawer: true,
      scaffoldKey: _scaffoldKey,
      body: Column(
        children: [
          SizedBox(height: 20),

          FancyTopBar(
            showLogo: true,
            onBack: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ), // Text("data"),
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                StudentHeaderCard(
                  name: _profileController.state?.profile?.fullName ?? "User",
                  rollNo: _profileController.state?.profile?.user?.id?.toString() ?? "--",
                  className: _profileController.state?.classroom?.name ?? "Class",
                ),

                SizedBox(height: 10),
                _buildGridData(),
                SizedBox(height: 20),

                _buildCard(
                  title: "Events & News",
                  subTitle: "Stay Updated on the Latest Accommodation Deals and Events",
                  onTap: () {
                    // MyNavigator.pushNamed(GoPaths.leaveManagementScreen);
                    // MyNavigator.pushNamed(GoPaths.changePasswordView);
                    MyNavigator.pushNamed(GoPaths.attendanceManagement);
                  },
                ),

                SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildGridData() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: manageList.length,
      itemBuilder: (context, index) {
        final item = manageList[index];

        return GestureDetector(
          onTap: () {
            final roleId = _profileController.state?.profile?.user?.roleId ?? 0;
            final className = _profileController.state?.classroom?.name ?? "";
            final grpChat = GoPaths.groupChat;
            if (item.path == grpChat) {
              MyNavigator.pushNamed(GoPaths.groupChat, extra: {"grpId": className});

              return;
            }

            if (item.key == "Manage Attendance") {
              logger.f("You are not authorized to access this feature");

              if (roleId != 4) {
                coreMessenger(
                  "You are not authorized to access this feature",
                  messageType: CoreScaffoldMessengerType.error,
                );
                return;
              }
            }

            MyNavigator.pushNamed(item.path);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            decoration: AppBoxDecoration.getBorderBoxDecoration(showShadow: true, borderRadius: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// GIF Image
                Image.asset(item.value, fit: BoxFit.contain, height: 50, width: 50),
                SizedBox(height: 10),

                /// Title
                Flexible(
                  child: Text(
                    item.key == "Group Chat"
                        ? "${_profileController.state?.classroom?.name ?? "Class"} Chat"
                        : item.key,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildCard({required String title, required String subTitle, required Function() onTap}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.23,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      clipBehavior: Clip.hardEdge,
      decoration: AppBoxDecoration.getBoxDecoration(
        showShadow: true,
        borderRadius: 20,
        color: AppColors.white,
      ),
      child: Stack(
        children: [
          Positioned.fill(child: SvgPicture.asset(AssetPaths.cardBGSVG, fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.only(left: 26, right: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Text(
                  title ?? "Events & News",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  subTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w100),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: AppBoxDecoration.getBoxDecoration(
                      showShadow: false,
                      borderRadius: 10,
                    ),
                    child: Text(
                      "Explore Latest Updates",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StudentHeaderCard extends StatelessWidget {
  final String? name;
  final String? rollNo;
  final String? className;
  final String? lottieAsset;

  const StudentHeaderCard({
    super.key,
    required this.name,
    required this.rollNo,
    required this.className,
    this.lottieAsset = AssetPaths.cuteBabyJSON,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppBoxDecoration.getBoxDecoration(showShadow: true, borderRadius: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Lottie.asset(lottieAsset!, height: 80, width: 80),

              const SizedBox(width: 12),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hello!", style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 2),
                  Text(
                    name ?? "Student",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Roll No : ${rollNo ?? '--'}", style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 2),
              Text(
                className ?? "",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
