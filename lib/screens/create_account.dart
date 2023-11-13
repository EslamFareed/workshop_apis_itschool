import 'package:flutter/material.dart';
import 'package:workshop_apis_itschool/repos/dio_helper.dart';
import 'package:workshop_apis_itschool/repos/end_points.dart';
import 'package:workshop_apis_itschool/repos/navigation_helper.dart';

class CreateAccountScreen extends StatelessWidget {
  CreateAccountScreen({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Name",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
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
                _createAccount(context);
              },
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }

  _createAccount(BuildContext context) {
    DioHelper.dio.post(createAccountApiUrl, data: {
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "avatar": "https://picsum.photos/800"
    }).then((response) async {
      if (response.statusCode == 201) {
        //! show success message
        //! navigate to home screen

        NavigationHelper.showMessage(context, "Created Successfully");

        Navigator.pop(context);
      } else {
        //! Show Error Message
        NavigationHelper.showMessage(
            context, "Create Error, Please Check your Data");
      }
    }).catchError((error) {
      print(error.toString());
      NavigationHelper.showMessage(
          context, "Create Error, Please Check your Data");
    });
  }
}
