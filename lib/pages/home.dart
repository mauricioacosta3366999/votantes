import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:votantes/pages/agregarVotantes.dart';
import 'package:votantes/pages/login.dart';
import 'package:votantes/pages/widgets/appbar.dart';
import 'package:votantes/pages/widgets/backImage.dart';
import 'package:votantes/pages/widgets/textButton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const PreferredSize(preferredSize: Size(0, 60), child: MyAppbar()),
      body: Stack(children: [
        const BackgroundImage(),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextButton(
                  text: 'Agregar votantes',
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AgregarVotantes()));
                  }),
              MyTextButton(text: 'Ver lista de votantes', function: () {}),
              MyTextButton(text: 'Dia D', function: () {}),
              MyTextButton(
                  text: 'Desconectarse',
                  function: () {
                    logout();
                  }),
            ],
          ),
        )
      ]),
    );
  }

  Future<void> logout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Estás seguro de que quieres cerrar la sesión?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Cerrar sesión'),
              onPressed: () async {
                await storage.deleteAll();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        );
      },
    );
  }
}
