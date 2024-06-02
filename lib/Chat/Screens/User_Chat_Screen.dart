import 'package:flutter/material.dart';

import '../../../Global/Functions/Colors.dart';
import '../../../Global/Widgets/AppBar.dart';

class User_Chat_Screen extends StatefulWidget {
  const User_Chat_Screen({super.key});
  static const routeName = 'User-Chat';

  @override
  State<User_Chat_Screen> createState() => _User_Chat_ScreenState();
}

class _User_Chat_ScreenState extends State<User_Chat_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get_White,
      appBar: C_AppBar(title: 'Chats'),
    );
  }
}
