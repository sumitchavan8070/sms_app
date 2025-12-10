import 'package:flutter/material.dart';
import 'package:school_management/utils/navigation/go_paths.dart';
import 'package:school_management/utils/navigation/navigator.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final PageController _pageController = PageController();
  int currentStep = 0;

  // Form data
  String? profileImageUrl;
  String fullName = "";
  String profession = "";
  String experience = "";
  String location = "";

  List<String> skills = [];
  final TextEditingController skillCtrl = TextEditingController();

  String instagram = "";
  String youtube = "";

  void nextPage() {
    if (currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Last step → complete
      Navigator.pop(context);
    }
  }

  void skip() {
    // Navigator.pop(context);
    MyNavigator.pushNamed(GoPaths.onboarding);
  }

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
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Setup Your Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: skip,
                          child: const Text(
                            "Skip",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // PROGRESS BAR
                    Row(
                      children: List.generate(3, (index) {
                        bool active = index <= currentStep;

                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: active == true
                                  ? Colors.white.withOpacity(0.15)
                                  : Colors.white.withOpacity(0.15),
                              gradient: active
                                  ? const LinearGradient(colors: [Colors.purple, Colors.pink])
                                  : null,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // PAGEVIEW
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (i) => setState(() => currentStep = i),
                  children: [buildBasicInfoPage(), buildSkillsPage(), buildPortfolioPage()],
                ),
              ),

              // FOOTER BUTTON
              Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: nextPage,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      currentStep == 2 ? "Complete Setup" : "Continue",
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PAGE 1 — BASIC INFO
  // ---------------------------------------------------------------------------
  Widget buildBasicInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text("Basic Information", style: TextStyle(color: Colors.white, fontSize: 22)),
          const SizedBox(height: 6),
          const Text(
            "Let's start with the basics",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          const SizedBox(height: 30),

          // Profile Image
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(
                    () => profileImageUrl = "https://api.dicebear.com/7.x/avataaars/svg?seed=user",
                  );
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white12,
                      backgroundImage: profileImageUrl != null
                          ? NetworkImage(profileImageUrl!)
                          : null,
                      child: profileImageUrl == null
                          ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                          : null,
                    ),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [Colors.purple, Colors.pink]),
                      ),
                      child: const Icon(Icons.upload, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text("Upload profile picture", style: TextStyle(color: Colors.grey)),
            ],
          ),

          const SizedBox(height: 30),

          buildInput("Full Name", "Your name", onChanged: (v) => fullName = v),
          buildInput(
            "Profession",
            "e.g., Actor, Director, Cinematographer",
            icon: Icons.work,
            onChanged: (v) => profession = v,
          ),

          const SizedBox(height: 10),
          buildExperienceSelector(),

          buildInput(
            "Location",
            "City, State",
            icon: Icons.location_on,
            onChanged: (v) => location = v,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // EXPERIENCE SELECTOR
  Widget buildExperienceSelector() {
    List<String> levels = ["Beginner", "Intermediate", "Expert"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Experience Level", style: TextStyle(color: Colors.grey, fontSize: 15)),
        const SizedBox(height: 8),
        Row(
          children: levels.map((level) {
            bool isSelected = experience == level;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => experience = level),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(colors: [Colors.purple, Colors.pink])
                        : null,
                    borderRadius: BorderRadius.circular(12),
                    border: !isSelected ? Border.all(color: Colors.white24) : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.06),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    level,
                    style: TextStyle(color: isSelected ? Colors.white : Colors.grey),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Text input
  Widget buildInput(String label, String hint, {IconData? icon, Function(String)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 15)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                fillColor: Colors.transparent,

                prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PAGE 2 — SKILLS
  // ---------------------------------------------------------------------------
  Widget buildSkillsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text("Skills & Expertise", style: TextStyle(color: Colors.white, fontSize: 22)),
          const SizedBox(height: 6),
          const Text("Add your skills and specializations", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),

          // Input + Add Button
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: TextField(
                    controller: skillCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      fillColor: Colors.transparent,

                      hintText: "e.g., Acting, Editing",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  if (skillCtrl.text.trim().isEmpty) return;
                  setState(() {
                    skills.add(skillCtrl.text.trim());
                    skillCtrl.clear();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text("Add", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // SKILL TAGS
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills
                .map(
                  (s) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(s, style: const TextStyle(color: Colors.white)),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => setState(() => skills.remove(s)),
                          child: const Icon(Icons.close, size: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 25),

          // QUICK ADD
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Quick add:", style: TextStyle(color: Colors.grey, fontSize: 15)),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                [
                  "Acting",
                  "Direction",
                  "Cinematography",
                  "Editing",
                  "Sound Design",
                  "Lighting",
                ].map((skill) {
                  return GestureDetector(
                    onTap: () {
                      if (!skills.contains(skill)) {
                        setState(() => skills.add(skill));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text("+ $skill", style: const TextStyle(color: Colors.white)),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PAGE 3 — PORTFOLIO
  // ---------------------------------------------------------------------------
  Widget buildPortfolioPage() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [Color.fromARGB(60, 155, 89, 182), Color.fromARGB(60, 231, 76, 60)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.emoji_events, color: Colors.purpleAccent, size: 26),
                    SizedBox(width: 8),
                    Text(
                      "Complete your profile to unlock:",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text("• Priority in search results", style: TextStyle(color: Colors.white70)),
                Text("• Direct messaging with recruiters", style: TextStyle(color: Colors.white70)),
                Text("• Featured talent badge", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 10),

          const Text(
            "Portfolio & Social Links",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(height: 6),
          const Text(
            "Showcase your work and connect profiles",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),

          // Instagram
          buildInput(
            "Instagram",
            "@username",
            icon: Icons.camera_alt,
            onChanged: (v) => instagram = v,
          ),

          // YouTube
          buildInput(
            "YouTube",
            "Channel URL",
            icon: Icons.video_collection,
            onChanged: (v) => youtube = v,
          ),

          const SizedBox(height: 20),

          const Text("Portfolio", style: TextStyle(color: Colors.grey, fontSize: 15)),
          const SizedBox(height: 8),

          // Upload Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white30, width: 2),
              color: Colors.white.withOpacity(0.03),
            ),
            child: Column(
              children: const [
                Icon(Icons.upload, color: Colors.grey, size: 32),
                SizedBox(height: 10),
                Text("Upload photos", style: TextStyle(color: Colors.white)),
                SizedBox(height: 6),
                Text("Max 10 files, up to 2Mb each", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
