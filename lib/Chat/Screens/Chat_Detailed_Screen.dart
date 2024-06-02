import 'package:flutter/material.dart';

import '../../../Global/Functions/Colors.dart';
import '../../../Global/Widgets/AppBar.dart';

import '../../../Chat/Providers/User_Chat_Model.dart';

class Chat_Detailed_Screen extends StatefulWidget {
  const Chat_Detailed_Screen({super.key});
  static const routeName = 'Chat-Detailed';

  @override
  State<Chat_Detailed_Screen> createState() => _Chat_Detailed_ScreenState();
}

class _Chat_Detailed_ScreenState extends State<Chat_Detailed_Screen> {
  var _did_change = true;
  late User_Chat_Model user_chat;

  @override
  void didChangeDependencies() {
    if (_did_change) {
      user_chat = ModalRoute.of(context)!.settings.arguments as User_Chat_Model;
      _did_change = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get_White,
      appBar: C_AppBar(
        title: user_chat.user_name,
        is_show_divider: true,
      ),
    );
  }
}
