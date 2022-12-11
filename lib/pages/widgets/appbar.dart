import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:votantes/appConfig.dart';

class MyAppbar extends StatefulWidget {
  const MyAppbar({super.key});

  @override
  State<MyAppbar> createState() => _MyAppbarState();
}

class _MyAppbarState extends State<MyAppbar> {
  final storage = const FlutterSecureStorage();
  String userName = '';
  @override
  void initState() {
    getUserName();
    super.initState();
  }

  getUserName() async {
    userName = (await storage.read(key: 'userName'))!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text('Bienvenido $userName'),
      backgroundColor: AppCongig().prymaryColor,
    );
  }
}
