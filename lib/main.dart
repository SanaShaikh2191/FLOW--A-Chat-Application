import 'package:firebase_core/firebase_core.dart';
import 'package:flow/config/theme/app_theme.dart';
import 'package:flow/data/services/service_locator.dart';
import 'package:flow/firebase_options.dart';
import 'package:flow/presentation/screens/auth/login_screen.dart';
import 'package:flow/presentation/screens/signup_screen.dart';
import 'package:flow/router/app_router.dart';
import 'package:flutter/material.dart';

void main() async {
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: getIt<AppRouter>().navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      home: LoginScreen(),
    );
  }
}
// get it ---> service locator---> delivery boy
// bloc and cubit