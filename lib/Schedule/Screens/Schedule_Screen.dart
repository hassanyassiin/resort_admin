import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../Global/Functions/Colors.dart';
import '../../../../Global/Functions/Errors.dart';

import '../../../../Global/Widgets/Texts.dart';
import '../../../../Global/Widgets/Failed.dart';
import '../../../../Global/Widgets/AppBar.dart';

import '../../../../Global/Screens/Loading_Screen.dart';

import '../../../../Global/Alert_Dialogs/Alert_Dialog_For_Confirmation.dart';

import '../../../../Schedule/Providers/Schedules_Model.dart';
import '../../../../Schedule/Screens/Modify_Schedule_Screen.dart';

class Schedule_Screen extends StatefulWidget {
  const Schedule_Screen({super.key});
  static const routeName = 'Schedule';

  @override
  State<Schedule_Screen> createState() => _Schedule_ScreenState();
}

class _Schedule_ScreenState extends State<Schedule_Screen> {
  Future<void> Delete_Schedule({required int id}) async {
    var is_deleted = await C_Alert_Dialog_For_Confirmation(
      context: context,
      button_one_title: 'Delete',
      content: 'Delete this schedule ?',
    );

    if (!is_deleted || !mounted) {
      return;
    }

    Loading_Screen(context: context);

    try {
      await Provider.of<Schedules_Model>(context, listen: false)
          .Delete_Schedule(schedule_id: id);

      if (mounted) {
        // To Popup the Loading Screen.
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        // To Popup the Loading Screen.
        Navigator.pop(context);
        return Error_Dialog(error: error.toString(), context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final schedules = Provider.of<Schedules_Model>(context, listen: false);

    return FutureBuilder(
      future: !schedules.Get_Is_get_Schedule_Success
          ? schedules.Get_Schedules()
          : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading_Scaffold(
            appBar_title: 'Schedule',
            is_show_appBar_divider: true,
            is_show_appBar_progress_indicator: true,
          );
        } else if (snapshot.hasError) {
          return Failed_Scaffold(
            appBar_title: 'Schedule',
            is_allow_refresh: true,
            is_show_appBar_divider: true,
            onRefresh_tap: () => setState(() {}),
            is_show_appBar_progress_indicator: true,
            error_message: snapshot.error.toString(),
          );
        } else {
          return Consumer<Schedules_Model>(
            builder: (context, schedules, child) {
              return Scaffold(
                backgroundColor: Get_White,
                appBar: C_AppBar(
                  title: 'Schedule',
                  is_show_divider: true,
                  suffix_widgets: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: UnconstrainedBox(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            Modify_Schedule_Screen.routeName,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: Get_Black, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.8.h))),
                            child:
                                Icon(Icons.add, color: Get_Black, size: 2.3.h),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                body: schedules.Get_Local_Schedules.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Center(
                          child: C_Text(
                            color: Get_Grey,
                            font_size: 1.5,
                            text: 'There is no schedules yet, start adding +',
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.5.h),
                        itemCount: schedules.Get_Local_Schedules.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.5.h, horizontal: 2.w),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 0.5, color: Get_Grey300),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                SizedBox(
                                  width: 80.w,
                                  child: Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        C_Text(
                                          font_size: 1.7,
                                          text: schedules
                                              .Get_Local_Schedules[index]
                                              .region,
                                        ),
                                        SizedBox(height: 1.h),
                                        C_Text(
                                          font_size: 1.5,
                                          text: schedules
                                              .Get_Local_Schedules[index].date,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Delete_Schedule(
                                      id: schedules
                                          .Get_Local_Schedules[index].id),
                                  child: Icon(
                                    size: 2.2.h,
                                    Icons.delete,
                                    color: Get_Red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              );
            },
          );
        }
      },
    );
  }
}
