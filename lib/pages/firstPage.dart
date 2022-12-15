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

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: BackgroundImage());
  }

  @override
  void initState() {
    userDataCheck();
    super.initState();
  }

  userDataCheck() async {
    String? value = await storage.read(key: 'token');
    String? userName = await storage.read(key: 'userId');
    print(value);
    print(userName);
    if (mounted) {
      if (value != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
        return;
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    }
  }
}
