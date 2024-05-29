import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';
import '../../../Global/Widgets/AppBar.dart';
import '../../../Global/Widgets/Failed.dart';

import '../../../Categories/Providers/Category_Model.dart';

import '../../../Products/Screens/Modify_Product_Screen.dart';

class Product_Screen extends StatefulWidget {
  const Product_Screen({super.key});
  static const routeName = 'Products';

  @override
  State<Product_Screen> createState() => _Product_ScreenState();
}

class _Product_ScreenState extends State<Product_Screen> {
  var is_edit = false;
  var _did_change = true;

  late Category_Model category;

  @override
  void didChangeDependencies() {
    if (_did_change) {
      category = ModalRoute.of(context)!.settings.arguments as Category_Model;
      _did_change = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: !category.Get_Is_Get_Products_Success
          ? category.Get_Products()
          : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading_Scaffold(
            appBar_title: category.title,
            is_show_appBar_divider: true,
            is_show_appBar_progress_indicator: true,
          );
        } else if (snapshot.hasError) {
          return Failed_Scaffold(
            appBar_title: category.title,
            is_show_appBar_divider: true,
            is_allow_refresh: true,
            onRefresh_tap: () => setState(() {}),
            is_show_appBar_progress_indicator: true,
            error_message: snapshot.error.toString(),
          );
        } else {
          return Scaffold(
            backgroundColor: Get_White,
            appBar: C_AppBar(
              title: category.title,
              is_show_divider: true,
              suffix_widgets: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: UnconstrainedBox(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        Modify_Product_Screen.routeName,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: Get_Black, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(0.8.h))),
                        child: Icon(Icons.add, color: Get_Black, size: 2.3.h),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
