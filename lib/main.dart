import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supercab_admin/DataSource/invoice.dart';
import 'package:supercab_admin/UIScreen/SingIn.dart';
import 'package:supercab_admin/Utils/routeGenerator.dart';



void main() async
{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Super Cab',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(250, 206, 0, 1),
          accentColor: Color.fromRGBO(250, 206, 0, 1),
          fontFamily: 'Montserrat',
          textTheme: TextTheme(
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/splash',
        onGenerateRoute: RouteGenerator.generateRoute);
  }
}

