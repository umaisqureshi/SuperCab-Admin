import 'package:flutter/material.dart';
import 'package:supercab_admin/UIScreen/AdminScreen.dart';
import 'package:supercab_admin/UIScreen/CreatePost.dart';
import 'package:supercab_admin/UIScreen/SingIn.dart';
import 'package:supercab_admin/UIScreen/Users.dart';
import 'package:supercab_admin/UIScreen/splashScreen.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/signIn':
        return MaterialPageRoute(builder: (_) => SignIn());
      case '/home':
        return MaterialPageRoute(builder: (_) => AdminPanelHome());
      case '/post':
        return MaterialPageRoute(builder: (_) => CreatePost());
      case '/users':
        return MaterialPageRoute(builder: (_) => Users());
      default:
        return null;
    }
  }
}
