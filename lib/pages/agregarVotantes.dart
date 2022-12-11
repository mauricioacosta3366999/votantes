import 'package:flutter/material.dart';
import 'package:votantes/appConfig.dart';
import 'package:votantes/pages/widgets/appbar.dart';
import 'package:votantes/pages/widgets/backImage.dart';
import 'package:votantes/pages/widgets/prymaryButton.dart';
import 'package:votantes/pages/widgets/textField.dart';

class AgregarVotantes extends StatefulWidget {
  const AgregarVotantes({super.key});

  @override
  State<AgregarVotantes> createState() => _AgregarVotantesState();
}

class _AgregarVotantesState extends State<AgregarVotantes> {
  final cdiController = TextEditingController();
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const PreferredSize(preferredSize: Size(0, 60), child: MyAppbar()),
      body: Stack(
        children: [
          const BackgroundImage(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_circle_left_outlined,
                    color: Colors.white,
                    size: 50,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  Text(
                    'Agregar Votantes',
                    style: AppCongig().prymaryStrongTextStyle,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Text(
                    'Cargá el número de cédula',
                    style: AppCongig().prymaryTextStyle,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  MyTextField(
                      icon: const Icon(
                        Icons.chrome_reader_mode_rounded,
                        color: Colors.white,
                      ),
                      controller: cdiController,
                      labelText: "Número de CDI"),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  MyTextField(
                      icon: const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      controller: phoneController,
                      labelText: "Número de teléfono"),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  PrymaryButton(
                    text: 'Buscar datos',
                    function: () {},
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
