import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Infos.dart';
import '../../../Global/Functions/Colors.dart';

Widget C_Text({
  int? max_lines,
  double height = 1.15,
  String weight = '400',
  Color color = Colors.black,
  required String text,
  required double font_size,
  double? letter_spacing,
  TextAlign text_align = TextAlign.start,
  TextDecoration text_decoration = TextDecoration.none,
  bool is_ltr = false,
}) {
  return Directionality(
    textDirection: is_ltr
        ? TextDirection.ltr
        : (lang == 'Ar' ? TextDirection.rtl : TextDirection.ltr),
    child: Text(
      text,
      maxLines: max_lines,
      textAlign: text_align,
      style: TextStyle(
        height: height,
        color: color,
        fontSize: font_size.h,
        fontWeight: weights[weight],
        decoration: text_decoration,
        letterSpacing: letter_spacing,
        overflow: max_lines != null ? TextOverflow.ellipsis : null,
      ),
    ),
  );
}

Widget C_Rich_Text({
  required String a_text,
  required double a_size,
  int? max_lines,
  double height = 1.15,
  String a_weight = '500',
  String b_weight = '400',
  Color a_color = Colors.black,
  Color b_color = Colors.grey,
  TextAlign text_align = TextAlign.start,
  String? b_text,
  double? b_size,
  TextDecoration a_text_decoration = TextDecoration.none,
  TextSpan? c_text_span,
}) {
  return RichText(
    maxLines: max_lines,
    textAlign: text_align,
    overflow: max_lines != null ? TextOverflow.ellipsis : TextOverflow.clip,
    text: TextSpan(
      text: a_text,
      style: TextStyle(
        height: height,
        fontSize: a_size.h,
        color: a_color,
        fontWeight: weights[a_weight],
        decoration: a_text_decoration,
        overflow: max_lines != null ? TextOverflow.ellipsis : TextOverflow.clip,
      ),
      children: <TextSpan>[
        if (b_text != null)
          TextSpan(
            text: b_text,
            style: TextStyle(
              height: height,
              fontSize: b_size?.h ?? (a_size - 0.4).h,
              color: b_color,
              fontWeight: weights[b_weight],
              overflow:
                  max_lines != null ? TextOverflow.ellipsis : TextOverflow.clip,
              decoration: TextDecoration.none,
            ),
          ),
        if (c_text_span != null) c_text_span,
      ],
    ),
  );
}

Widget Brasmela_Text() {
  return C_Text(
    text: '𝐁𝐫𝐚𝐬𝐦𝐞𝐥𝐚',
    font_size: 2.2,
    weight: '500',
    letter_spacing: 2,
  );
}
