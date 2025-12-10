import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:school_management/utils/navigation/go_paths.dart';
import 'package:school_management/utils/navigation/navigator.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool useEmail = true;
  bool showPassword = false;

  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0A24), Color(0xFF22003D), Color(0xFF0F0A24)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Blurred Orbs
            Positioned(
              top: 100,
              left: 30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 120,
              right: 30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Main Content
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      Text(
                        isLogin ? "Welcome Back!" : "Join LetsFAME",
                        // style: GoogleFonts.poppins(
                        //   color: Colors.white,
                        //   fontSize: 32,
                        //   fontWeight: FontWeight.w600,
                        // ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        isLogin
                            ? "Sign in to continue your journey"
                            : "Create your account and get started",
                        style: TextStyle(color: Colors.grey.shade300),
                      ),

                      const SizedBox(height: 25),

                      // Email / Phone Switch (Login Only)
                      if (isLogin)
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withOpacity(0.12)),
                          ),
                          child: Row(
                            children: [
                              _toggleButton(
                                title: "Email",
                                selected: useEmail,
                                onTap: () => setState(() => useEmail = true),
                              ),
                              _toggleButton(
                                title: "Phone",
                                selected: !useEmail,
                                onTap: () => setState(() => useEmail = false),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Name (Signup)
                      if (!isLogin) _buildInput("Full Name", Icons.person, nameCtrl),

                      // Email Input
                      if (useEmail || !isLogin) _buildInput("Email Address", Icons.mail, emailCtrl),

                      // Phone Input (Login Only)
                      if (!useEmail && isLogin) _buildInput("Phone Number", Icons.phone, phoneCtrl),

                      _buildPassword(),

                      const SizedBox(height: 10),

                      if (isLogin)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.purple.shade300),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Sign In / Sign Up Button
                      _mainButton(isLogin ? "Sign In" : "Sign Up", () {
                        MyNavigator.pushNamed(GoPaths.profileSetUp);
                      }),

                      const SizedBox(height: 25),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Container(height: 1, color: Colors.white.withOpacity(0.2)),
                          ),
                          const SizedBox(width: 10),
                          Text("or continue with", style: TextStyle(color: Colors.grey.shade400)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(height: 1, color: Colors.white.withOpacity(0.2)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Google & Apple Buttons
                      Row(
                        children: [
                          Expanded(child: _socialButton("Google", "G")),
                          const SizedBox(width: 12),
                          Expanded(child: _socialButton("Apple", "")),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Guest Button
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Continue as Guest",
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Toggle login/signup
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLogin ? "Don't have an account? " : "Already have an account? ",
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => isLogin = !isLogin),
                            child: Text(
                              isLogin ? "Sign Up" : "Sign In",
                              style: TextStyle(
                                color: Colors.purple.shade300,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: selected ? const LinearGradient(colors: [Colors.purple, Colors.pink]) : null,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(color: selected ? Colors.white : Colors.grey.shade400),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, IconData icon, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade300)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: TextFormField(
            controller: ctrl,

            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey),
              border: InputBorder.none,
              hintText: label,
              fillColor: Colors.transparent,
              hintStyle: TextStyle(color: Colors.grey.shade500),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: TextStyle(color: Colors.grey.shade300)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: TextField(
            controller: passCtrl,
            obscureText: !showPassword,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              fillColor: Colors.transparent,

              prefixIcon: const Icon(Icons.lock, color: Colors.grey),
              suffixIcon: GestureDetector(
                onTap: () => setState(() => showPassword = !showPassword),
                child: Icon(
                  showPassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
              ),
              border: InputBorder.none,
              hintText: "•••••••",
              hintStyle: TextStyle(color: Colors.grey.shade500),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _mainButton(String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.purple, Colors.pinkAccent]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 17)),
      ),
    );
  }

  Widget _socialButton(String text, String icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(color: Colors.white, fontSize: 20)),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
