import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:echojar/app/navigation/router.dart';
import 'package:echojar/app/theme/app_colors.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  List<PageViewModel> _buildPages(BuildContext context) {
    return [
      PageViewModel(
        title: "🎙️ Save Your Voice",
        body: "Say something you want to hear later.\n"
            "Keep it safe inside your own digital jar.",
        image: _buildIcon(CupertinoIcons.mic_fill, AppColors.textPrimary),
        decoration: _pageDecoration(),
      ),
      PageViewModel(
        title: "⏳ Wait for the Right Time",
        body: "Pick when it will come back to you.\n"
            "Days, months, or years later — it’s a surprise.",
        image: _buildIcon(CupertinoIcons.time_solid, AppColors.textPrimary),
        decoration: _pageDecoration(),
      ),
      PageViewModel(
        title: "✨ Hear It Again",
        body: "When the day comes, open your jar.\n"
            "Feel the moment all over again.",
        image: _buildIcon(CupertinoIcons.play_circle_fill, AppColors.textPrimary),
        decoration: _pageDecoration(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: _buildPages(context),
      onDone: () => context.goNamed('Home'),
      onSkip: () => context.goNamed('Home'),
      showSkipButton: true,
      showBackButton: true,
      skipOrBackFlex: 1,
      nextFlex: 1,
      back: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          "Prev",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.black87),
        ),
      ),
      skip: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          "Skip",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.black87),
        ),
      ),
      next: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.arrow_forward, color: AppColors.primary, size: 32),
      ),
      done: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          "Start",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.black87),
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Colors.grey.shade400,
        activeSize: const Size(24.0, 10.0),
        activeColor: AppColors.primaryLight,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      animationDuration: 500,
      curve: Curves.easeInOut,
    );
  }

  static Widget _buildIcon(IconData icon, Color color) {
    return Center(
      child: Icon(
        icon,
        size: 160,
        color: color,
      ),
    );
  }

  static PageDecoration _pageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 18,
        height: 1.5,
        color: Colors.black54,
      ),
      bodyPadding: EdgeInsets.symmetric(horizontal: 20),
      imagePadding: EdgeInsets.only(top: 40, bottom: 20),
    );
  }
}
