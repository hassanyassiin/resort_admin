import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../Authentication/Providers/Authentication.dart';

import '../../../Global/Functions/Http_Exception.dart';

import '../../../Users/Providers/User_Model.dart';

Future<List<User_Model>> Cd_Get_Users({required String filter}) async {
  final url = Get_REQUEST_URL(url: '/admin-user/get-Users', arguments: {
    'filter': filter,
  });

  try {
    final response = await http.get(url,
        headers: <String, String>{'Authorization': 'Bearer $Get_Token'});

    final response_data = json.decode(response.body);

    if (response.statusCode != 200) {
      throw C_Http_Exception(response_data['ErrorFound'] ?? '');
    }

    List<User_Model> received_users = [];

    for (var user in response_data['users']) {
      received_users.add(
        User_Model(
          id: user['id'],
          longitude: double.parse(user['longitude'].toString()),
          region: user['region'],
          latitude: double.parse(user['latitude'].toString()),
          phone_number: user['phonenumber'],
          email: user['email'],
          status: user['status'],
          last_name: user['lastName'],
          first_name: user['firstName'],
          profile_pic: Get_PHOTO_URL(
            folder: 'profile',
            image: user['profilePic'],
          ),
        ),
      );
    }

    return received_users;
  } catch (error) {
    rethrow;
  }
}
