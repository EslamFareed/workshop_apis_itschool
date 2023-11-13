import 'package:flutter/material.dart';
import 'package:workshop_apis_itschool/repos/dio_helper.dart';
import 'package:workshop_apis_itschool/repos/shared_helper.dart';

import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedHelper.init();
  DioHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}


//! Login 
//! Create Account 
//! Get Products 
//! Get Categories
//! Tap Category Show Products inside this Category
//! Tap Any Product Open Details For This Product
//! Search by product name

//? Next Time And Filter ( With Price )
//? Next Time Get Profile
//? Next Time Logout