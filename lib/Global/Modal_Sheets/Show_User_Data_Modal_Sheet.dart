import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';

import '../../../Global/Widgets/Texts.dart';
import '../../../Global/Widgets/Toasts.dart';
import '../../../Global/Widgets/Buttons.dart';
import '../../../Global/Widgets/Phone_Number_TextFormField.dart';

import '../../../Global/Alert_Dialogs/Alert_Dialog.dart';

import '../../../Global/Photos/Network_Image.dart';

import '../../../Global/Modal_Sheets/Header_For_Modal_Sheet.dart';

import '../../../Users/Providers/User_Model.dart';

Future<void> Show_User_Data_Modal_Sheet({
  required User_Model user,
  required BuildContext context,
}) async {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Get_White,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(2.h))),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Header_For_Modal_Sheet(title: 'User Information'),
              Divider(thickness: 0.6, color: Get_Grey300),
              Align(
                alignment: Alignment.center,
                child: Circle_Network_Image(
                  width: 20,
                  image: user.profile_pic,
                ),
              ),
              SizedBox(height: 1.5.h),
              Align(
                alignment: Alignment.center,
                child: C_Text(
                  weight: '500',
                  font_size: 1.8,
                  text: '${user.first_name} ${user.last_name}',
                ),
              ),
              SizedBox(height: 2.5.h),
              C_Rich_Text(
                  a_size: 1.65,
                  a_text: 'Region: ',
                  a_color: Get_Black,
                  a_weight: '600',
                  max_lines: 1,
                  b_text: user.region,
                  b_size: 1.5,
                  b_weight: '500'),
              SizedBox(height: 1.h),
              C_Rich_Text(
                  a_size: 1.65,
                  a_text: 'Status: ',
                  a_color: Get_Black,
                  a_weight: '600',
                  max_lines: 1,
                  b_text: user.status,
                  b_size: 1.5,
                  b_weight: '500'),
              SizedBox(height: 1.h),
              C_Rich_Text(
                  a_size: 1.65,
                  a_text: 'Phone Number: ',
                  a_color: Get_Black,
                  a_weight: '600',
                  max_lines: 1,
                  b_text: '+${Format_Phone_Number(user.phone_number)}',
                  b_size: 1.5,
                  b_weight: '500'),
              SizedBox(height: 1.h),
              C_Rich_Text(
                  a_size: 1.65,
                  a_text: 'Email Address: ',
                  a_color: Get_Black,
                  a_weight: '600',
                  max_lines: 1,
                  b_text: user.email,
                  b_size: 1.5,
                  b_weight: '500'),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          top: 4.h, bottom: 1.h, left: 2.w, right: 2.w),
                      child: C_Rounded_Button(
                        title: 'Copy Location',
                        border_radius: 1.5,
                        button_color: Get_Primary,
                        onPressed: () async {
                          try {
                            await Clipboard.setData(ClipboardData(
                                text:
                                    'Longitude: ${user.longitude} Latitude: ${user.latitude}'));
                          } catch (error) {
                            if (context.mounted) {
                              return C_Alert_Dialog(
                                context: context,
                                button_one_title: 'Try again!',
                                title: 'Something went wrong!',
                                content: 'Didn\'t Saved successfully',
                              );
                            }
                          }

                          if (!context.mounted) {
                            return;
                          }

                          Show_Text_Toast(
                            context: context,
                            icon: Icons.check,
                            back_ground_color: Get_Primary,
                            text: 'Location has been saved successfully',
                          );

                          return Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          top: 4.h, bottom: 1.h, left: 2.w, right: 2.w),
                      child: C_Rounded_Button(
                        title: 'Done',
                        border_radius: 1.5,
                        button_color: Get_Black,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
