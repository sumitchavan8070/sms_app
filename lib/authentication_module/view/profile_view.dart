import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management/authentication_module/controller/client_profile_controller.dart';
import 'package:school_management/constants.dart';
import 'package:school_management/utils/common_model.dart';
import 'package:school_management/utils/components/custom_tab_bar.dart';
import 'package:school_management/utils/constants/app_box_decoration.dart';
import 'package:school_management/utils/constants/app_colors.dart';
import 'package:school_management/utils/constants/app_page.dart';
import 'package:school_management/utils/constants/asset_paths.dart';
import 'package:school_management/utils/constants/core_prep_paths.dart';
import 'package:school_management/utils/constants/fancy_app_bar.dart';
import 'package:school_management/utils/navigation/go_paths.dart';
import 'package:school_management/utils/navigation/navigator.dart';

final _profileController = Get.put(ClientProfileController(), permanent: true);

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _tabList = [
    "Personal Details",
    "Contact Details",
    "Guardian Info",
    "Academic Details",
    "Student ID Card",
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // _profileController.getClientProfile();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageView(

      body: Column(
        children: [
          const FancyTopBar(
            backButton: true,
            title: "Profile",
            showLogo: false,
            showActions: false,
          ),
          SizedBox(height: 20),

          /// ------------------- Profile Image -------------------
          Container(
            height: 130,
            clipBehavior: Clip.hardEdge,
            decoration: AppBoxDecoration.getBorderBoxDecoration(
              showShadow: true,
              color: const Color(0xFFF4F7FE).withOpacity(0.40),
              borderRadius: 100,
              borderColor: Colors.transparent,
            ),
            child: Image.asset(AssetPaths.userPNG, fit: BoxFit.fill),
          ),

          SizedBox(height: 16),

          /// ------------------- Name -------------------
          _profileController.obx((state) {
            final fullName = (state?.profile?.fullName ?? "").trim();
            return Text(
              fullName,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
            );
          }),

          /// ------------------- Subtitle -------------------
          _profileController.obx((state) {
            final role = state?.profile?.user?.role?.name ?? "";
            final school = state?.profile?.user?.school?.name ?? "";

            return Text(
              "$role • $school",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.silverChalice),
            );
          }),

          SizedBox(height: 20),

          /// ------------------- TABS & TAB CONTENT -------------------
          Expanded(
            child: DefaultTabController(
              length: _tabList.length,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: CustomTabBar(
                      horizontalPadding: 0,
                      height: 94,
                      hasInnerShadow: true,
                      tabAlignment: TabAlignment.start,
                      tabList: _tabList,
                      isScrollable: true,
                      showBorder: true,
                      fillColor: Colors.white,
                      borderColor: const Color(0xFFEAEAEA),
                      borderRadius: 10,
                    ),
                  ),

                  SizedBox(height: 16),

                  Expanded(
                    child: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildPersonalDetails(),
                        _buildContactDetails(),
                        _buildGuardianInfo(),
                        _buildAcademicDetails(),
                        _buildIdCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      floatLocation: FloatingActionButtonLocation.endFloat,
      floatingActionWidget: GestureDetector(
        onTap: () {
          print("Floating Lottie pressed");
          corePrefs.erase();
          MyNavigator.popUntilAndPushNamed(GoPaths.splash);
        },
        child: Lottie.asset(AssetPaths.cuteBabyJSON, height: 80, width: 80),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // 1️⃣ PERSONAL DETAILS TAB
  // -------------------------------------------------------------------------
  Widget _buildPersonalDetails() {
    return _profileController.obx((state) {
      final p = state?.profile;

      return _dynamicBox([
        KeyValuePair(key: "Full Name", value: p?.fullName ?? ""),
        KeyValuePair(key: "Gender", value: p?.gender ?? ""),
        KeyValuePair(key: "Date of Birth", value: p?.dob ?? ""),
      ]);
    });
  }

  // -------------------------------------------------------------------------
  // 2️⃣ CONTACT DETAILS TAB
  // -------------------------------------------------------------------------
  Widget _buildContactDetails() {
    return _profileController.obx((state) {
      final p = state?.profile;

      return _dynamicBox([
        KeyValuePair(key: "Phone", value: p?.phone ?? ""),
        KeyValuePair(key: "Email", value: p?.user?.email ?? ""),
        KeyValuePair(key: "Address", value: p?.address ?? ""),
      ]);
    });
  }

  // -------------------------------------------------------------------------
  // 3️⃣ GUARDIAN DETAILS TAB
  // -------------------------------------------------------------------------
  Widget _buildGuardianInfo() {
    return _dynamicBox([
      KeyValuePair(key: "Guardian Name", value: "Not Provided"),
      KeyValuePair(key: "Relation", value: "-"),
      KeyValuePair(key: "Contact", value: "-"),
    ]);
  }

  // -------------------------------------------------------------------------
  // 4️⃣ ACADEMIC DETAILS TAB
  // -------------------------------------------------------------------------
  Widget _buildAcademicDetails() {
    return _profileController.obx((state) {
      final user = state?.profile?.user;

      final salary = user?.salaries?.isNotEmpty == true ? user!.salaries!.first : null;
      final leave = user?.leaves?.isNotEmpty == true ? user!.leaves!.first : null;

      return _dynamicBox([
        KeyValuePair(key: "Role", value: user?.role?.name ?? ""),
        KeyValuePair(key: "School", value: user?.school?.name ?? ""),
        if (salary != null)
          KeyValuePair(key: "Last Salary", value: "₹${salary.totalSalary} (${salary.month})"),
        if (leave != null)
          KeyValuePair(key: "Recent Leave", value: "${leave.startDate} → ${leave.endDate}"),
      ]);
    });
  }

  // -------------------------------------------------------------------------
  // 5️⃣ ID CARD TAB
  // -------------------------------------------------------------------------
  Widget _buildIdCard() {
    return _profileController.obx((state) {
      final p = state?.profile;

      return Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(radius: 40, backgroundColor: Colors.blueGrey),
              SizedBox(height: 12),

              Text(p?.fullName ?? "", style: Theme.of(context).textTheme.titleMedium),

              SizedBox(height: 4),
              Text(p?.user?.role?.name ?? "", style: TextStyle(color: Colors.grey)),

              SizedBox(height: 12),
              Text(p?.user?.school?.name ?? "", textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    });
  }

  // -------------------------------------------------------------------------
  // SHARED REUSABLE BOX BUILDER
  // -------------------------------------------------------------------------
  Widget _dynamicBox(List<KeyValuePair> items) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: AppBoxDecoration.getBorderBoxDecoration(
          showShadow: false,
          borderRadius: 12,
          borderColor: AppColors.balticSea.withOpacity(0.20),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) =>
              Divider(height: 32, color: AppColors.darkJungleGreen.withOpacity(0.20)),
          itemBuilder: (_, index) {
            final entry = items[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.circle, size: 10, color: AppColors.primaryColor),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${entry.key}: ${entry.value}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
