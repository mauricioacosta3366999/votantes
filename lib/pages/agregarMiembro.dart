import 'package:flutter/material.dart';
import 'package:votantes/appConfig.dart';
import 'package:votantes/pages/widgets/appbar.dart';
import 'package:votantes/pages/widgets/backImage.dart';
import 'package:votantes/pages/widgets/prymaryButton.dart';
import 'package:votantes/pages/widgets/textField.dart';
import 'package:votantes/services/endpoints.dart';

class AgregarMiembro extends StatefulWidget {
  const AgregarMiembro({super.key});
  @override
  State<AgregarMiembro> createState() => _AgregarMiembroState();
}

class _AgregarMiembroState extends State<AgregarMiembro> {
  final cdiController = TextEditingController();
  final passController = TextEditingController();
  bool loading = false;
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
                  Text(
                    'Agregar Miembro',
                    style: AppCongig().prymaryStrongTextStyle,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Text(
                    'Creá los credenciales',
                    style: AppCongig().prymaryTextStyle,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  MyTextField(
                      icon: const Icon(
                        Icons.chrome_reader_mode_rounded,
                        color: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      controller: cdiController,
                      labelText: "Número de CDI"),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  MyTextField(
                    icon: const Icon(
                      Icons.key,
                      color: Colors.white,
                    ),
                    controller: passController,
                    labelText: 'Contraseña',
                    isPass: true,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  loading
                      ? const CircularProgressIndicator()
                      : PrymaryButton(
                          text: 'Crear miembro',
                          function: () async {
                            setState(() => loading = true);
                            try {
                              var res = await Endpoints().memberCreate(
                                  ci: cdiController.text,
                                  pass: passController.text);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(res,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.green[400],
                                ),
                              );
                            } catch (e) {
                              print(e);
                            }
                            setState(() => loading = false);
                            Navigator.pop(context);
                          },
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
