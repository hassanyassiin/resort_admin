import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Widgets/Texts.dart';

import '../../../Global/Photos/Network_Image.dart';

Widget Category_Item({
  required int id,
  double? width,
  required String title,
  required String image,
  double font_size = 1.8,
  int title_max_lines = 2,
  double border_radius = 1.5,
  double space_height = 1,
  required void Function() onTap,
  void Function()? onLongPress,
}) {
  return GestureDetector(
    key: ValueKey(id),
    onTap: onTap,
    onLongPress: onLongPress,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: width?.w,
          child: Rect_Network_Image(
            image: image,
            aspect_ratio: 1 / 1,
            key: ValueKey(id * 1000),
            border_radius: border_radius,
          ),
        ),
        SizedBox(height: space_height.h),
        Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: C_Text(
              text: title,
              weight: '500',
              font_size: font_size,
              max_lines: title_max_lines,
              text_align: TextAlign.center,
            ),
          ),
        ),
      ],
    ),
  );
}
