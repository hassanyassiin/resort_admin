import 'package:flutter/material.dart';

import '../../../Global/Functions/Colors.dart';
import '../../Global/Widgets/AppBar.dart';

class Users_Screen extends StatefulWidget {
  const Users_Screen({super.key});
  static const routeName = 'Users';

  @override
  State<Users_Screen> createState() => _Users_ScreenState();
}

class _Users_ScreenState extends State<Users_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get_White,
      appBar: C_AppBar(),
    );
  }
}
