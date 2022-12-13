import 'package:flutter/material.dart';
import 'package:votantes/pages/agregarVotantes.dart';
import 'package:votantes/pages/widgets/appbar.dart';
import 'package:votantes/pages/widgets/backImage.dart';
import 'package:votantes/pages/widgets/textButton.dart';

class DayD extends StatefulWidget {
  const DayD({super.key});

  @override
  State<DayD> createState() => _DayDState();
}

class _DayDState extends State<DayD> {
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
                  text: 'Agregar voto',
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AgregarVotantes(onlySearchCdi: true)));
                  }),
              MyTextButton(text: 'Ver faltantes', function: () {}),
            ],
          ),
        )
      ]),
    );
  }
}
