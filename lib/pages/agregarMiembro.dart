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
  final nameController = TextEditingController();
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
                        Icons.person,
                        color: Colors.white,
                      ),
                      controller: nameController,
                      labelText: "Nombre"),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : PrymaryButton(
                          text: 'Crear miembro',
                          function: () async {
                            bool validate = valiations();
                            setState(() => loading = true);
                            if (validate) {
                              try {
                                var res = await Endpoints().memberCreate(
                                    ci: cdiController.text,
                                    pass: passController.text,
                                    nombre: nameController.text);
                                if (!mounted) return;
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(showSnack(res, 3, true));
                              } catch (e) {
                                print(e);
                              }
                              setState(() => loading = false);
                              Navigator.pop(context);
                            }
                            setState(() => loading = false);
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

  valiations() {
    if (cdiController.text.isEmpty || passController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(showSnack('Completa todos los campos', 3, false));
      return false;
    } else if (cdiController.text.length != 7) {
      ScaffoldMessenger.of(context)
          .showSnackBar(showSnack('CDI inválido.', 3, false));
      return false;
    } else if (passController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
          showSnack('La contraseña debe contener minimo 8 digitos.', 3, false));
      return false;
    } else {
      return true;
    }
  }

  showSnack(String text, int duration, bool isGreen) {
    return SnackBar(
      duration: Duration(seconds: duration),
      content: Text(text),
      backgroundColor: isGreen ? Colors.green[400] : Colors.red[400],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
