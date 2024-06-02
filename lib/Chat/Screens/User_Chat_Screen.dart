import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';
import '../../../Global/Widgets/AppBar.dart';
import '../../../Global/Widgets/Failed.dart';
import '../../../Global/Widgets/Texts.dart';

import '../../../Global/Photos/Network_Image.dart';

import '../../../Chat/Providers/User_Chat_Model.dart';
import '../../../Chat/Screens/Chat_Detailed_Screen.dart';
import '../../../Chat/Continued_Providers/Get_User_Chats.dart';

class User_Chat_Screen extends StatefulWidget {
  const User_Chat_Screen({super.key});
  static const routeName = 'User-Chat';

  @override
  State<User_Chat_Screen> createState() => _User_Chat_ScreenState();
}

class _User_Chat_ScreenState extends State<User_Chat_Screen> {
  var is_first_request_success = false;

  List<User_Chat_Model> user_chats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get_Shein,
      appBar: C_AppBar(
        title: 'Chats',
        appBar_color: Get_Shein,
      ),
      body: FutureBuilder(
        future: !is_first_request_success
            ? Cd_Get_User_Chats().then((value) {
                is_first_request_success = true;
                user_chats = value;
              })
            : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CupertinoActivityIndicator(
                radius: 1.5.h,
                color: Get_Black,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Failed_Icon_and_Text(
                is_allow_refresh: true,
                onTap: () => setState(() {}),
              ),
            );
          } else {
            return user_chats.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: C_Text(
                        font_size: 1.5,
                        color: Get_Grey,
                        text: 'There are no users yet.',
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: user_chats.length,
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          Chat_Detailed_Screen.routeName,
                          arguments: user_chats[index],
                        ),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 2.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: Get_White,
                            borderRadius:
                                BorderRadius.all(Radius.circular(1.5.h)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Circle_Network_Image(
                                width: 12,
                                image: user_chats[index].user_pic,
                              ),
                              SizedBox(width: 2.w),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    C_Text(
                                      font_size: 1.7,
                                      text: user_chats[index].user_name,
                                    ),
                                    SizedBox(height: 1.h),
                                    C_Text(
                                      font_size: 1.5,
                                      weight: '500',
                                      color: Get_Grey,
                                      text: user_chats[index].chats.isNotEmpty
                                          ? user_chats[index].chats.last.text
                                          : 'start a new message...',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          }
        },
      ),
    );
  }
}
