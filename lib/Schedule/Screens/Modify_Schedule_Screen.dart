import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Errors.dart';
import '../../../Global/Functions/Infos.dart';
import '../../../Global/Functions/Colors.dart';

import '../../../Global/Widgets/AppBar.dart';
import '../../../Global/Widgets/Buttons.dart';
import '../../../Global/Widgets/Texts.dart';
import '../../../Global/Widgets/Cupertino_Date.dart';

import '../../../Global/Screens/Loading_Screen.dart';

import '../../../Global/Modal_Sheets/Show_Radio_Buttons_Modal_Sheet.dart';

import '../../../Schedule/Providers/Schedules_Model.dart';

class Modify_Schedule_Screen extends StatefulWidget {
  const Modify_Schedule_Screen({super.key});
  static const routeName = 'Modify-Schedule';

  @override
  State<Modify_Schedule_Screen> createState() => _Modify_Schedule_ScreenState();
}

class _Modify_Schedule_ScreenState extends State<Modify_Schedule_Screen> {
  var tapped_controller = TextEditingController();

  var _did_change = true;

  late String edited_region;

  @override
  void didChangeDependencies() {
    if (_did_change) {
      var arguments = ModalRoute.of(context)!.settings.arguments as String?;

      edited_region =
          arguments ?? 'Beirut'; // TODO CHANGE THIS WHEN MODIFYING REGIONS.

      tapped_controller.text =
          DateFormat("dd MMMM yyyy").format(DateTime.now()).toString();

      _did_change = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    tapped_controller.dispose();
    super.dispose();
  }

  Future<void> On_Change_Time() async {
    await Show_Cupertino_Date_Picker_ModalSheet(
      day: 'Choose Date',
      context: context,
      tapped_controller: tapped_controller,
    );

    return FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> Submit() async {
    Loading_Screen(context: context);
    try {
      await Provider.of<Schedules_Model>(context, listen: false)
          .Create_Schedule(date: tapped_controller.text, region: edited_region);

      if (mounted) {
        // To Popup the Loading Screen.
        Navigator.pop(context);
        // To Popup the Screen.
        return Navigator.pop(context);
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
    return Scaffold(
      backgroundColor: Get_White,
      appBar: C_AppBar(
        title: 'Modify Schedule',
        is_show_divider: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        children: <Widget>[
          C_Text(
            weight: '600',
            font_size: 1.7,
            text: 'Choose Region',
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus!.unfocus();

                Show_Radio_Buttons_Modal_Sheets(
                  context: context,
                  initial_value: edited_region,
                  title: 'Change Region',
                  list_items: regions,
                  onChanged: (value) => setState(() {
                    edited_region = value;
                  }),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 1.5.h, bottom: 1.5.h),
                padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 2.w),
                decoration: BoxDecoration(
                    color: Get_Trans,
                    borderRadius: BorderRadius.all(Radius.circular(1.2.h)),
                    border: Border.all(
                        color: Get_Grey.withOpacity(0.25), width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    C_Text(
                      font_size: 1.65,
                      text: edited_region,
                    ),
                    Icon(
                      size: 2.5.h,
                      Icons.arrow_drop_down_sharp,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            child: C_Text(
              weight: '600',
              font_size: 1.7,
              text: 'Choose Date',
            ),
          ),
          GestureDetector(
            onTap: On_Change_Time,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                  color: Get_Trans,
                  border:
                      Border.all(color: Get_Grey.withOpacity(0.25), width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(1.2.h))),
              child: C_Text(
                weight: '500',
                font_size: 1.65,
                text: tapped_controller.text.trim().isEmpty
                    ? DateFormat("dd MMMM yyyy")
                        .format(DateTime.now())
                        .toString()
                    : tapped_controller.text,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: C_Rounded_Button(
            border_radius: 1.2,
            title: 'Add To Schedule',
            button_color: Get_Primary,
            onPressed: Submit,
          ),
        ),
      ),
    );
  }
}
