import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:school_management/authentication_module/controller/client_profile_controller.dart';
import 'package:school_management/utils/constants/app_colors.dart';
import 'package:school_management/utils/constants/app_page.dart';

import '../../constants.dart';
import '../../utils/constants/fancy_app_bar.dart' show FancyTopBar;

final _profileController = Get.find<ClientProfileController>();

class GroupChatScreen extends StatefulWidget {
  final String groupId; // e.g. "class_8A"

  const GroupChatScreen({super.key, required this.groupId});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController messageController = TextEditingController();

  late final num roleId;
  late final String userId;

  @override
  void initState() {
    super.initState();
    roleId = _profileController.state?.profile?.user?.roleId ?? 0;
    userId = _profileController.state?.profile?.user?.id.toString() ?? "";
  }

  Future<void> deleteAllMessages(String groupId) async {
    final messages = await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .get();

    for (var doc in messages.docs) {
      await doc.reference.delete();
    }
  }

  /// SEND A TEXT MESSAGE
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection("groups")
        .doc(widget.groupId)
        .collection("messages")
        .add({
          "text": messageController.text.trim(),
          "senderId": userId,
          "type": "text",
          "timestamp": FieldValue.serverTimestamp(),
        });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageView(
      body: Column(
        children: [
          FancyTopBar(
            showLogo: false,
            showActions: false,
            backButton: true,
            title: "${widget.groupId} - Chat",
          ),
          // 🔥 FIRESTORE REAL-TIME MESSAGES STREAM
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("groups")
                    .doc(widget.groupId)
                    .collection("messages")
                    .orderBy("timestamp", descending: false)
                    .snapshots(),
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  logger.f("grp id ${widget.groupId}");

                  final messages = snapshot.data!.docs;

                  if (messages.isEmpty) {
                    return Center(
                      child: Text("No Chat Found", style: Theme.of(context).textTheme.displaySmall),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 12),
                    itemCount: messages.length,
                    itemBuilder: (_, index) {
                      final msg = messages[index];
                      final bool isMine = msg["senderId"] == userId;
                      final String text = msg["text"] ?? "";

                      return ChatBubble(isSender: isMine, message: text);
                    },
                  );
                },
              ),
            ),
          ),

          // 🔥 INPUT – Shown ONLY for Teachers
          if (roleId == 4)
            _floatButton(sendMessage, messageController)
          else
            Container(
              padding: const EdgeInsets.all(12),
              child: const Text(
                "You can read messages only.",
                style: TextStyle(color: Colors.grey),
              ),
            ),

          // if (roleId == 4) ElevatedButton(onPressed: () {}, child: Text("Clear Group ")),
        ],
      ),
      // ),
      // floatLocation: FloatingActionButtonLocation.endDocked,
      // floatingActionWidget: _floatButton(),
    );
  }

  _floatButton(Function() onSend, TextEditingController controller) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: Colors.white),
      margin: EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 10),

              // 🔥 MESSAGE INPUT FIELD
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Type message...",
                    filled: true,
                    fillColor: AppColors.primaryColor.withOpacity(0.15),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // 🔥 SEND BUTTON
              IconButton(
                icon: const Icon(Icons.send, color: AppColors.primaryColor),
                onPressed: onSend,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ---- CHAT BUBBLE ----
class ChatBubble extends StatelessWidget {
  final bool isSender;
  final String message;

  const ChatBubble({super.key, required this.isSender, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(

          top: 6,
          bottom: 6,
          right: isSender ? 0 : 40,
          left: isSender ? 40 : 0,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSender ? AppColors.primaryColor : const Color(0xFF00BF6D).withOpacity(0.10),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(message, style: TextStyle(color: isSender ? Colors.white : Colors.black87)),
      ),
    );
  }
}
