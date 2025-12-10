import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/attendance_module/controller/get_announcements_controller.dart';
import 'package:school_management/constants.dart';
import 'package:school_management/utils/constants/app_colors.dart';
import 'package:school_management/utils/constants/app_page.dart';
import 'package:school_management/utils/constants/fancy_app_bar.dart';

final _getAnnouncementsController = Get.put(GetAnnouncementsController());

class GetAnnouncementsView extends StatefulWidget {
  const GetAnnouncementsView({super.key});

  @override
  State<GetAnnouncementsView> createState() => _GetAnnouncementsViewState();
}

class _GetAnnouncementsViewState extends State<GetAnnouncementsView> {
  @override
  void initState() {
    super.initState();
    _getAnnouncementsController.getAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageView(
      body: Column(
        children: [
          FancyTopBar(
            showLogo: false,
            title: "Announcements",
            backButton: true,
            showActions: false,
          ),

          _getAnnouncementsController.obx((state) {
            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(12),
              itemCount: state?.data?.length ?? 0,
              itemBuilder: (context, index) {
                final item = state?.data?[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TITLE
                        Text(
                          item?.title ?? "",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 8),

                        /// MESSAGE
                        Text(
                          item?.message ?? "",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[800]),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Chip(
                              label: Text(
                                item?.audience?.toUpperCase() ?? "",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(color: Colors.white),
                              ),
                              backgroundColor: AppColors.primaryColor,
                            ),

                            /// DATE
                            Text(
                              item?.postedOn ?? "",
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        const Divider(),

                        /// Posted By + School
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "By: ${item?.postedBy?.username}",
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                            ),
                            Text(
                              item?.schoolName ?? "",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
