import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../Authentication/Providers/Authentication.dart';

import '../../../Global/Functions/Http_Exception.dart';

import '../../../Schedule/Providers/Schedule_Model.dart';
import '../../../Schedule/Continued_Providers/Create_Schedule.dart';
import '../../../Schedule/Continued_Providers/Get_Schedules.dart';

class Schedules_Model extends ChangeNotifier {
  List<Schedule_Model> _schedules = [];
  List<Schedule_Model> get Get_Local_Schedules => _schedules;

  var is_get_schedules_success = false;
  get Get_Is_get_Schedule_Success => is_get_schedules_success;

  Future<void> Get_Schedules() async {
    try {
      var received_schedules = await Cd_Get_Schedules();

      _schedules = received_schedules;
      is_get_schedules_success = true;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> Create_Schedule({
    required String date,
    required String region,
  }) async {
    try {
      var response_id = await Cd_Create_Schedule(region: region, date: date);

      _schedules.insert(
        0,
        Schedule_Model(id: response_id, date: date, region: region),
      );

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> Delete_Schedule({required int schedule_id}) async {
    final url = Get_REQUEST_URL(
        url: 'admin-schedule/delete-Schedule',
        arguments: {'scheduleId': schedule_id.toString()});

    try {
      final response = await http.delete(
        url,
        headers: <String, String>{'Authorization': 'Bearer $Get_Token'},
      );

      final response_data = json.decode(response.body);

      if (response.statusCode != 200) {
        throw C_Http_Exception(response_data['ErrorFound'] ?? '');
      }

      _schedules.removeWhere((schedule) => schedule.id == schedule_id);

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
