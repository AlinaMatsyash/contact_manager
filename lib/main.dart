import 'package:flutter/material.dart';
import 'package:contact_manager/screens/splash.dart';
import 'screens/contact_list_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/edit_contact_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_contacts_example',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/contactList': (context) => const ContactListScreen(),
        '/contact': (context) => const ContactScreen(),
        '/editContact': (context) => const EditContactScreen(),
      },
    );
  }
}
