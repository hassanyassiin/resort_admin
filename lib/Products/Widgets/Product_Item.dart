import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';
import '../../../Global/Widgets/Texts.dart';
import '../../../Global/Photos/Network_Image.dart';

import '../../../Products/Providers/Product_Model.dart';
import '../../../Products/Screens/Modify_Product_Screen.dart';

import '../../../Categories/Providers/Category_Model.dart';

class Product_Item extends StatelessWidget {
  final Category_Model category;
  const Product_Item({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product_Model>(context);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, Modify_Product_Screen.routeName,
          arguments: {
            'Category': category,
            'Product': product,
          }),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
        decoration: BoxDecoration(
            color: Get_White,
            borderRadius: BorderRadius.all(Radius.circular(1.5.h))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              width: 10.h,
              child: Rect_Network_Image(
                image: product.photo,
              ),
            ),
            SizedBox(width: 3.w),
            C_Text(
              weight: '500',
              font_size: 1.6,
              text: product.title,
            ),
          ],
        ),
      ),
    );
  }
}
