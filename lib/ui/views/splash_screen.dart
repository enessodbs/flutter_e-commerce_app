import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/ui/views/auth_check.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: LottieBuilder.asset("animation/Animation - 1731254392624.json"),
      nextScreen: AuthCheck(),
      duration: 2800,
      backgroundColor: Colors.white,
      centered: true,
      splashIconSize: 2500.0,
    );
  }
}
