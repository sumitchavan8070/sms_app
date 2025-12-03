import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:school_management/authentication_module/controller/client_login_controller.dart';
import 'package:school_management/screens/entryPoint/landing_view.dart';
import 'package:school_management/utils/navigation/go_paths.dart';
import 'package:school_management/utils/navigation/navigator.dart';

final _clientLoginController = Get.put(ClientLoginController());

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ADDED
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger reset;
  late SMITrigger confetti;

  // RIVE INIT
  void _onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    );
    artboard.addController(controller!);
    error = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller = StateMachineController.fromArtboard(
      artboard,
      "State Machine 1",
    );
    artboard.addController(controller!);
    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  // 🔥 NEW — LOGIN + ANIMATION HANDLING
  void signIn(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      error.fire();
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });

    // Call API
    final result = await _clientLoginController.clientLogin(
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
    );

    // SUCCESS
    if (result == 1) {
      success.fire();

      Future.delayed(const Duration(seconds: 2), () {
        setState(() => isShowLoading = false);
        confetti.fire();

        if (!context.mounted) return;

        /// Navigate to next screen
        // Get.off(() => const EntryPoint());
        MyNavigator.popUntilAndPushNamed(GoPaths.landingView);
      });
    }
    // ERROR
    else {
      error.fire();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => isShowLoading = false);
        reset.fire();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // EMAIL
              const Text("Email", style: TextStyle(color: Colors.black54)),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  controller: emailCtrl,
                  validator: (value) {
                    if (value!.isEmpty) return "";
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SvgPicture.asset("assets/icons/email.svg"),
                    ),
                  ),
                ),
              ),

              // PASSWORD
              const Text("Password", style: TextStyle(color: Colors.black54)),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  controller: passwordCtrl,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) return "";
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SvgPicture.asset("assets/icons/password.svg"),
                    ),
                  ),
                ),
              ),

              // SIGN IN BUTTON
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: ElevatedButton.icon(
                  onPressed: () => signIn(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF77D8E),
                    minimumSize: const Size(double.infinity, 56),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                  icon: const Icon(CupertinoIcons.arrow_right, color: Color(0xFFFE0037)),
                  label: const Text("Sign In"),
                ),
              ),
            ],
          ),
        ),

        // ✔ LOADING ANIMATION
        if (isShowLoading)
          CustomPositioned(
            child: RiveAnimation.asset(
              'assets/RiveAssets/check.riv',
              fit: BoxFit.cover,
              onInit: _onCheckRiveInit,
            ),
          ),

        // ✔ CONFETTI ANIMATION
        if (isShowConfetti)
          CustomPositioned(
            scale: 6,
            child: RiveAnimation.asset(
              "assets/RiveAssets/confetti.riv",
              fit: BoxFit.cover,
              onInit: _onConfettiRiveInit,
            ),
          ),
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, this.scale = 1, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 100,
            width: 100,
            child: Transform.scale(scale: scale, child: child),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
