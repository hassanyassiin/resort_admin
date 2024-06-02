import 'package:flutter/material.dart';

import '../../../Chat/Providers/Chat_Model.dart';

class User_Chat_Model extends ChangeNotifier {
  final int id;
  final bool is_refresh;
  final String user_name;
  final String user_pic;
  final List<Chat_Model> chats;

  User_Chat_Model({
    required this.id,
    required this.is_refresh,
    required this.user_name,
    required this.user_pic,
    required this.chats,
  });
}
