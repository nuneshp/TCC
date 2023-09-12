import 'package:flutter/material.dart';
import 'package:tcc_hugo/routes.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AmigoPet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.initial,
      routes: Routes.list,
      navigatorKey: Routes.navigatorKey,
     
    );
  }
}
