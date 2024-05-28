import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../Authentication/Providers/Authentication.dart';

import '../../../Global/Functions/Http_Exception.dart';

Future<int> Cd_Create_Schedule({
  required String region,
  required String date,
}) async {
  final url = Get_REQUEST_URL(url: 'admin-schedule/Create-Schedule');

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $Get_Token'
      },
      body: json.encode({
        'date': date,
        'region': region,
      }),
    );

    final response_data = json.decode(response.body);

    if (response.statusCode != 200) {
      throw C_Http_Exception(response_data['ErrorFound'] ?? '');
    }

    return response_data['id'];
  } catch (error) {
    rethrow;
  }
}
