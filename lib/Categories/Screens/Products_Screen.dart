import 'package:flutter/material.dart';

import '../../../Global/Functions/Colors.dart';
import '../../../Global/Widgets/AppBar.dart';

import '../../../Categories/Providers/Category_Model.dart';

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
    return Scaffold(
      backgroundColor: Get_White,
      appBar: C_AppBar(title: category.title),
    );
  }
}
