import 'package:flutter/material.dart';

import '../../../Global/Functions/Colors.dart';
import '../../../Global/Widgets/AppBar.dart';

class Modify_Product_Screen extends StatefulWidget {
  const Modify_Product_Screen({super.key});
  static const routeName = 'Modify-Product';

  @override
  State<Modify_Product_Screen> createState() => _Modify_Product_ScreenState();
}

class _Modify_Product_ScreenState extends State<Modify_Product_Screen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Get_White,
      appBar: C_AppBar(title: 'Modify Product'),
    );
  }
}
