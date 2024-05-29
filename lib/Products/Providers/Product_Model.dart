import 'package:flutter/material.dart';

class Product_Model extends ChangeNotifier {
  final int id;
  String title;
  String photo;

  Product_Model({
    required this.id,
    required this.title,
    required this.photo,
  });
}
