import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/authentication_module/controller/client_login_controller.dart';

import 'package:school_management/screens/onboding/components/sign_in_form.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // For slide animation from top
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void closeScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SlideTransition(
        position: _slideAnimation,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 32),

                      /// Title
                      const Text(
                        "Sign in",
                        style: TextStyle(
                          fontSize: 34,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Text(
                        "Access to 240+ hours of content. Learn design and code, by building real apps with Flutter and Swift.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),

                      const SizedBox(height: 32),


                      /// Sign In Form
                      const SignInForm(),

                      const SizedBox(height: 24),

                      /// OR Divider
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "OR",
                              style: TextStyle(color: Colors.black26, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // const Text(
                      //   "Sign up with Email, Apple or Google",
                      //   style: TextStyle(color: Colors.black54),
                      // ),
                      // const SizedBox(height: 24),

                      /// Social Buttons
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     IconButton(
                      //       onPressed: () {},
                      //       padding: EdgeInsets.zero,
                      //       icon: SvgPicture.asset(
                      //         "assets/icons/email_box.svg",
                      //         height: 64,
                      //         width: 64,
                      //       ),
                      //     ),
                      //     IconButton(
                      //       onPressed: () {},
                      //       padding: EdgeInsets.zero,
                      //       icon: SvgPicture.asset(
                      //         "assets/icons/apple_box.svg",
                      //         height: 64,
                      //         width: 64,
                      //       ),
                      //     ),
                      //     IconButton(
                      //       onPressed: () {},
                      //       padding: EdgeInsets.zero,
                      //       icon: SvgPicture.asset(
                      //         "assets/icons/google_box.svg",
                      //         height: 64,
                      //         width: 64,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),

                /// Close button
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: closeScreen,
                    icon: const Icon(Icons.close, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
