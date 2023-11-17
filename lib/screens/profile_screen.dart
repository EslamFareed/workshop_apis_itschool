import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:workshop_apis_itschool/models/profile_model.dart';
import 'package:workshop_apis_itschool/repos/dio_helper.dart';
import 'package:workshop_apis_itschool/repos/shared_helper.dart';

import '../repos/end_points.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<Response> _getProfile() {
    return DioHelper.dio.get(
      getProfileApiUrl,
      options: Options(
        headers: {
          "Authorization": "Bearer ${SharedHelper.prefs.getString("token")}"
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: FutureBuilder<Response>(
        future: _getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            var data = ProfileModel.fromJson(snapshot.data!.data);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(data.avatar!),
                ),
                ListTile(title: Text(data.name!)),
                ListTile(title: Text(data.email!)),
              ],
            );
          }
        },
      ),
    );
  }
}
