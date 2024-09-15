// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../Home/BottomNav/bottomnav.dart';
// import 'package:molle/Utils/constants.dart';
//
// import '../Tabs/tabs.dart';
//
// class Splash extends StatefulWidget {
//   const Splash({super.key});
//
//   @override
//   State<Splash> createState() => _SplashState();
// }
//
// class _SplashState extends State<Splash> {
//   final FlutterSecureStorage _storage = const FlutterSecureStorage();
//
//   @override
//   void initState() {
//     super.initState();
//     _navigateBasedOnLoginStatus();
//   }
//
//   Future<void> _navigateBasedOnLoginStatus() async {
//     final token = await _storage.read(key: 'auth_token');
//
//     // Simulating splash screen delay
//     await Future.delayed(const Duration(seconds: 4));
//
//     if (token != null) {
//       // If token exists, navigate directly to the home screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const BottomNav()),
//       );
//     } else {
//       // If no token, proceed to onboarding screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const OnboardingScreen()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: BoxDecoration(
//             gradient: LinearGradient(colors: [
//           ColorConstants.mainColor,
//           ColorConstants.mainColor2,
//         ])),
//         child: const Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image(image: AssetImage("assets/AppLogo.png")),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Home/BottomNav/bottomnav.dart';
import 'package:molle/Utils/constants.dart';
import '../Tabs/tabs.dart';
import '../Auth/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _navigateBasedOnLoginStatus();
  }

  Future<void> _navigateBasedOnLoginStatus() async {
    final token = await _storage.read(key: 'auth_token');

    // Simulating splash screen delay
    await Future.delayed(const Duration(seconds: 4));

    if (token != null) {
      // If token exists, navigate directly to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );
    } else {
      // If no token, proceed to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            ColorConstants.mainColor,
            ColorConstants.mainColor2,
          ]),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/AppLogo.png")),
          ],
        ),
      ),
    );
  }
}
