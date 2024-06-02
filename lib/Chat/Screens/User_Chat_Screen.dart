import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';
import '../../../Global/Widgets/AppBar.dart';
import '../../../Global/Widgets/Failed.dart';

import '../../../Chat/Continued_Providers/Get_User_Chats.dart';

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
      body: FutureBuilder(
        future: Cd_Get_User_Chats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CupertinoActivityIndicator(
                radius: 1.5.h,
                color: Get_Black,
              ),
            );
          } else if (snapshot.hasError) {
            return Failed_Icon_and_Text(
              is_allow_refresh: true,
              onTap: () => setState(() {}),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
