import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Authentication/Providers/Authentication.dart';
import '../../../Authentication/Screens/Login_Screen.dart';

import '../../../Global/Functions/Colors.dart';

import '../../../Global/Screens/Splash_Screen.dart';

import '../../../Global/Photos/Carousel_Slider.dart';

import '../../../Navigator_Screens/Chat_Screen.dart';
import '../../../Navigator_Screens/Users_Screen.dart';
import '../../../Navigator_Screens/Main_Screen.dart';

final navigator_key = GlobalKey<NavigatorState>();

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    return;
  };
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Get_Trans,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Authentication()),
        ChangeNotifierProvider(create: (context) => Carousel_Index_Notifier()),
      ],
      child: Consumer<Authentication>(
        builder: (context, auth, child) {
          return MaterialApp(
            title: 'Brasmela',
            themeMode: ThemeMode.light,
            navigatorKey: navigator_key,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: false),
            home: ResponsiveSizer(
              builder: (context, orientation, screenType) {
                return auth.Is_Auth
                    ? const Main_Screen()
                    : FutureBuilder(
                        future: auth.Try_Auto_Login(),
                        builder: (context, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? const Splash_Screen()
                                : const Login_Screen());
              },
            ),
            routes: {
              Login_Screen.routeName: (context) => const Login_Screen(),
              Chat_Screen.routeName: (context) => const Chat_Screen(),
              Users_Screen.routeName: (context) => const Users_Screen(),
            },
          );
        },
      ),
    );
  }
}