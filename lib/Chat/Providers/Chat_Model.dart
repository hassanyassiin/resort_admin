import 'package:flutter/cupertino.dart';

class Chat_Model extends ChangeNotifier {
  final int id;
  final String text;

  Chat_Model({required this.id, required this.text});
}
