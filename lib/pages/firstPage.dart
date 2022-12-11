import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:votantes/pages/home.dart';
import 'package:votantes/pages/login.dart';
import 'package:votantes/pages/widgets/backImage.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final storage = const FlutterSecureStorage();

  userDataCheck() async {
    String? value = await storage.read(key: 'token');
    if (value != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  void initState() {
    userDataCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: BackgroundImage());
  }
}
