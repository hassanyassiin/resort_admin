import 'dart:async';
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

  var _did_change = true;

  List<User_Chat_Model> user_chats = [];

  late Timer myTimer;

  @override
  void didChangeDependencies() {
    if (_did_change) {
      myTimer = Timer.periodic(
          const Duration(seconds: 1), (timer) => Fetch_User_Chats());

      _did_change = false;
    }
    super.didChangeDependencies();
  }

  Future<void> Fetch_User_Chats() async {
    if (is_first_request_success) {
      try {
        var received_user_chats = await Cd_Get_User_Chats();

        setState(() {
          user_chats = received_user_chats;
        });
      } catch (error) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get_White,
      appBar: C_AppBar(
        title: 'Chats',
        appBar_color: Get_White,
        is_show_divider: true,
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
                        EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.5.h),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          Chat_Detailed_Screen.routeName,
                          arguments: user_chats[index],
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.5.h),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                              width: 0.1,
                              color: Get_Grey,
                            )),
                            color: Get_White,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              SizedBox(
                                width: 70.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Circle_Network_Image(
                                      width: 12,
                                      image: user_chats[index].user_pic,
                                    ),
                                    SizedBox(width: 2.w),
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          C_Text(
                                              font_size: 1.7,
                                              text: user_chats[index].user_name,
                                              max_lines: 1),
                                          SizedBox(height: 1.h),
                                          C_Text(
                                            font_size: 1.5,
                                            weight: '500',
                                            color: Get_Grey,
                                            max_lines: 1,
                                            text:
                                                user_chats[index].last_message,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (user_chats[index].is_refresh)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: Get_Primary,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(0.5.h)),
                                  ),
                                  child: C_Text(
                                    weight: '500',
                                    text: 'New message',
                                    font_size: 1.2,
                                    color: Get_White,
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
