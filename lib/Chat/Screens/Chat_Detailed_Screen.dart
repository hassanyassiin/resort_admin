import 'dart:async';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';

import '../../../Global/Widgets/Texts.dart';
import '../../../Global/Widgets/Failed.dart';
import '../../../Global/Widgets/AppBar.dart';
import '../../../Global/Widgets/TextFormField.dart';

import '../../../Chat/Providers/Chat_Model.dart';
import '../../../Chat/Providers/User_Chat_Model.dart';
import '../../../Chat/Continued_Providers/Get_Chats.dart';

class Chat_Detailed_Screen extends StatefulWidget {
  const Chat_Detailed_Screen({super.key});
  static const routeName = 'Chat-Detailed';

  @override
  State<Chat_Detailed_Screen> createState() => _Chat_Detailed_ScreenState();
}

class _Chat_Detailed_ScreenState extends State<Chat_Detailed_Screen> {
  final controller = TextEditingController();

  var _did_change = true;
  late User_Chat_Model user_chat;

  List<Chat_Model> chats = [];

  var is_first_request_success = false;

  late Timer myTimer;

  @override
  void didChangeDependencies() {
    if (_did_change) {
      user_chat = ModalRoute.of(context)!.settings.arguments as User_Chat_Model;
      chats = user_chat.chats;

      myTimer =
          Timer.periodic(const Duration(seconds: 1), (timer) => Fetch_Chats());

      _did_change = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    myTimer.cancel();
    controller.dispose();
    super.dispose();
  }

  Future<void> Fetch_Chats() async {
    if (is_first_request_success) {
      try {
        var received_chats = await Cd_Get_Chats(user_chat_id: user_chat.id);

        setState(() {
          chats = received_chats;
        });
      } catch (error) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: !is_first_request_success
          ? Cd_Get_Chats(user_chat_id: user_chat.id).then((value) {
              chats = value;
              is_first_request_success = true;
            })
          : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading_Scaffold(
            appBar_title: user_chat.user_name,
            is_show_appBar_divider: true,
          );
        } else if (snapshot.hasError) {
          return Failed_Scaffold(
            is_allow_refresh: true,
            is_show_appBar_divider: true,
            appBar_title: user_chat.user_name,
            error_message: snapshot.error.toString(),
            onRefresh_tap: () => setState(() {}),
          );
        } else {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: Scaffold(
              backgroundColor: Get_White,
              appBar: C_AppBar(
                title: user_chat.user_name,
                is_show_divider: true,
              ),
              body: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return C_Text(
                    text: chats[index].text,
                    font_size: 1.5,
                  );
                },
              ),
              bottomSheet: Container(
                color: Get_White,
                margin: EdgeInsets.only(bottom: 2.h),
                padding: EdgeInsets.only(bottom: 2.h, left: 2.w, right: 2.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: C_TextFormField(
                        controller: controller,
                        vertical_content_padding: 1.2,
                        hint_text: 'Start a message..',
                        hint_text_size: 1.75,
                      ),
                    ),
                    SizedBox(
                      width: 14.w,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 4.h,
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: Get_Primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            size: 2.h,
                            color: Get_White,
                            Icons.arrow_forward_ios_rounded,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
