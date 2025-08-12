// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted) {
//         Get.offNamed('/login'); // ✅ Redirect to Login
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('lib/images/genie.png', width: 200),
//             const SizedBox(height: 20),
//             const CircularProgressIndicator(),
//           ],
//         ),
//       ),
//     );
//
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Get.offNamed('/login'); // Redirect to Login
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background image
          Image.asset('lib/images/genie.png', fit: BoxFit.cover),
          // Optional: You can overlay a semi-transparent color or loading spinner
          Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      ),
    );
  }
}
