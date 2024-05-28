import 'package:flutter/material.dart';

class Schedule_Model extends ChangeNotifier {
  final int id;
  final String date;
  final String region;

  Schedule_Model({
    required this.id,
    required this.date,
    required this.region,
  });
}
