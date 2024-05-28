import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../Authentication/Providers/Authentication.dart';

import '../../../Global/Functions/Http_Exception.dart';

import '../../../Schedule/Providers/Schedule_Model.dart';

Future<List<Schedule_Model>> Cd_Get_Schedules() async {
  final url = Get_REQUEST_URL(url: '/admin-schedule/get-Schedules');

  try {
    final response = await http.get(url,
        headers: <String, String>{'Authorization': 'Bearer $Get_Token'});

    final response_data = json.decode(response.body);

    if (response.statusCode != 200) {
      throw C_Http_Exception(response_data['ErrorFound'] ?? '');
    }

    List<Schedule_Model> received_schedules = [];

    for (var schedule in response_data['schedules']) {
      received_schedules.add(Schedule_Model(
        id: schedule['id'],
        date: schedule['date'],
        region: schedule['region'],
      ));
    }

    return received_schedules;
  } catch (error) {
    rethrow;
  }
}
