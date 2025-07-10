import 'package:flutter/material.dart';
import 'package:rent_house_application/views/change_password_screen.dart';
import 'package:rent_house_application/views/credit_package_screen.dart';
import 'package:rent_house_application/views/home_screen.dart';
import 'package:rent_house_application/views/login_screen.dart';
import 'package:rent_house_application/views/my_property_screen.dart';
import 'package:rent_house_application/views/post_property_screen.dart';
import 'package:rent_house_application/views/profile_screen.dart';
import 'package:rent_house_application/views/purchase_history_screen.dart';
import 'package:rent_house_application/views/register_screen.dart';
import 'package:rent_house_application/views/splash_screen.dart';
import 'package:rent_house_application/views/unlock_property_screen.dart';
import 'package:rent_house_application/views/user_home_screen.dart';

void main() {
  runApp(const RentHouseApp());
}

class RentHouseApp extends StatelessWidget {
  const RentHouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rent House',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/user_home': (context) => const UserHomeScreen(),
        '/unlock_property': (context) => const UnlockPropertyScreen(),
        '/credit_package': (context) => const CreditPackageScreen(),
        '/purchase_history': (context) => const PurchaseHistoryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/post_property': (context) => const PostPropertyScreen(),
        '/settings': (context) => const ChangePasswordScreen(),
        '/my_property': (context) => const MyPropertiesScreen(),


      },
    );
  }
}