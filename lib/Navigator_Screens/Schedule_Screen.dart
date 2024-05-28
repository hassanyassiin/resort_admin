import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';
import '../../../Global/Widgets/AppBar.dart';

class Schedule_Screen extends StatelessWidget {
  const Schedule_Screen({super.key});
  static const routeName = 'Schedule';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get_White,
      appBar: C_AppBar(title: 'Schedule'),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
      ),
    );
  }
}
