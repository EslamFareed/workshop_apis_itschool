import 'package:flutter/material.dart';
import 'package:workshop_apis_itschool/repos/dio_helper.dart';
import 'package:workshop_apis_itschool/repos/end_points.dart';
import 'package:workshop_apis_itschool/repos/navigation_helper.dart';
import 'package:workshop_apis_itschool/repos/shared_helper.dart';
import 'package:workshop_apis_itschool/screens/create_account.dart';
import 'package:workshop_apis_itschool/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
                prefixIcon: Icon(Icons.security),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: const Text("Login"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                NavigationHelper.goTo(CreateAccountScreen(), context);
              },
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }

  _login(BuildContext context) {
    DioHelper.dio.post(loginApiUrl, data: {
      "email": emailController.text,
      "password": passwordController.text
    }).then((response) async {
      if (response.statusCode == 201) {
        //! show success message
        //! navigate to home screen

        await SharedHelper.prefs.setBool("isLogin", true);
        await SharedHelper.prefs
            .setString("token", response.data["access_token"].toString())
            .then((value) {
          NavigationHelper.showMessage(context, "Login Successfully");

          NavigationHelper.goToAndOff(HomeScreen(), context);
        });
      } else {
        //! Show Error Message
        NavigationHelper.showMessage(
            context, "Login Error, Please Check your Data");
      }
    }).catchError((error) {
      print(error.toString());
      NavigationHelper.showMessage(
          context, "Login Error, Please Check your Data");
    });
    // try {
    //   Response response = await DioHelper.dio.post(loginApiUrl);
    // if (response.statusCode == 201) {
    //   //! show success message
    //   NavigationHelper.showMessage(context, "Login Successfully");
    //   NavigationHelper.goToAndOff(HomeScreen(), context);

    //   //! navigate to home screen
    // } else {
    //   //! Show Error Message
    // }
    // } catch (e) {
    //   print(e);
    // }
  }
}
