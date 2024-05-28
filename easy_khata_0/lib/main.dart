
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/addCustomer.dart';
import 'screens/email_verification.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/signup.dart';
import 'screens/splash_screen.dart';
import 'screens/updateAmountScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Khata',
      debugShowCheckedModeBanner: false,

      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),
        LoginPage.routeName : (context) => const LoginPage(),
        SignUpPage.routeName: (context) => const SignUpPage(),
        EmailVerification.routeName: (context) => const EmailVerification(),
        MainScreen.routeName: (context) => MainScreen(),
        AddCustomerScreen.routeName: (context) => AddCustomerScreen(),

      },

    );
  }
}
