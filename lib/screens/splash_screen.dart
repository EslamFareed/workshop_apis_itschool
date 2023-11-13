import 'package:flutter/material.dart';
import 'package:workshop_apis_itschool/repos/navigation_helper.dart';
import 'package:workshop_apis_itschool/repos/shared_helper.dart';
import 'package:workshop_apis_itschool/screens/home_screen.dart';
import 'package:workshop_apis_itschool/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //! Check Login if true go TO Home Screen
    //! else go to Login Screen
    Future.delayed(
      const Duration(seconds: 2),
      () {
        bool isLogin = SharedHelper.prefs.getBool("isLogin") ?? false;

        NavigationHelper.goToAndOff(
            isLogin ? HomeScreen() : LoginScreen(), context);
      },
    );
    return const Scaffold(
      body: Center(
        child: Icon(
          Icons.category,
          size: 150,
        ),
      ),
    );
  }
}
