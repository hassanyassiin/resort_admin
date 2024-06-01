import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../Global/Functions/Colors.dart';
import '../../../Global/Widgets/AppBar.dart';
import '../../../Global/Widgets/Failed.dart';
import '../../../Global/Widgets/Texts.dart';
import '../../../Global/Widgets/Toasts.dart';

import '../../../Global/Photos/Network_Image.dart';

import '../../../Global/Screens/Loading_Screen.dart';

import '../../../Global/Modal_Sheets/Show_User_Data_Modal_Sheet.dart';

import '../../../Users/Providers/User_Model.dart';

import '../../../Users/Continued_Providers/Get_Users.dart';

class Users_Screen extends StatefulWidget {
  const Users_Screen({super.key});
  static const routeName = 'Users';

  @override
  State<Users_Screen> createState() => _Users_ScreenState();
}

class _Users_ScreenState extends State<Users_Screen> {
  List<User_Model> users = [];
  var is_first_request_success = false;

  var filter = 'View All';

  List<String> filters = [
    'View All',
    'Proceed',
    'Delivered',
    'Not Yet',
  ];

  Future<void> Get_Filter_Users({required String received_filter}) async {
    if (filter == received_filter) {
      return;
    }

    Loading_Screen(context: context);

    try {
      var received_users = await Cd_Get_Users(filter: received_filter);

      if (mounted) {
        Navigator.pop(context);
        setState(() {
          users = received_users;
          filter = received_filter;
        });
      }
    } catch (error) {
      if (mounted) {
        Navigator.pop(context);
        return Show_Text_Toast(context: context, text: 'Something went wrong');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: !is_first_request_success
          ? Cd_Get_Users(filter: 'View All').then(
              (value) {
                users = value;
                is_first_request_success = true;
              },
            )
          : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading_Scaffold(
            appBar_color: Get_Shein,
            scaffold_color: Get_Shein,
            appBar_title: 'Users',
          );
        } else if (snapshot.hasError) {
          return Failed_Scaffold(
            appBar_title: 'Users',
            appBar_color: Get_Shein,
            scaffold_color: Get_Shein,
            error_message: snapshot.error.toString(),
          );
        } else {
          return Scaffold(
            backgroundColor: Get_Shein,
            appBar: C_AppBar(
              title: 'Users',
              appBar_color: Get_Shein,
              elevation: 0.2,
              bottom_widget: PreferredSize(
                preferredSize: Size.fromHeight(6.h),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ...List.generate(
                          4,
                          (index) {
                            return GestureDetector(
                              onTap: () => Get_Filter_Users(
                                  received_filter: filters[index]),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 2.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: filter == filters[index]
                                      ? Get_Primary
                                      : Get_White,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.h)),
                                ),
                                child: C_Text(
                                  weight: '500',
                                  text: filters[index],
                                  font_size: 1.5,
                                  color: filter == filters[index]
                                      ? Get_White
                                      : Get_Black,
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Get_Red200,
                            border: Border(
                              bottom:
                                  BorderSide(width: 0.5, color: Get_Grey300),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: users.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: C_Text(
                        font_size: 1.5,
                        color: Get_Grey,
                        text: filter == 'View All'
                            ? 'There are no users yet.'
                            : 'There are no users in $filter Status.',
                      ),
                    ),
                  )
                : ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Show_User_Data_Modal_Sheet(
                          user: users[index],
                          context: context,
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
                                image: users[index].profile_pic,
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
                                      text:
                                          "${users[index].first_name} ${users[index].last_name}",
                                    ),
                                    SizedBox(height: 1.h),
                                    C_Text(
                                      font_size: 1.5,
                                      color: Get_Grey,
                                      text: users[index].region,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        }
      },
    );
  }
}
