import 'package:flutter/material.dart';
import 'package:votantes/pages/home.dart';
import 'package:votantes/pages/widgets/backImage.dart';
import 'package:votantes/pages/widgets/prymaryButton.dart';
import 'package:votantes/pages/widgets/textField.dart';
import 'package:votantes/services/endpoints.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
      body: Stack(
        children: [
          const BackgroundImage(),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width * 0.3,
                    horizontal: MediaQuery.of(context).size.width * 0.15),
                child: Center(
                  child: Column(
                    children: [
                      MyTextField(
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        controller: emailController,
                        labelText: 'Usuario',
                      ),
                      const SizedBox(height: 30),
                      MyTextField(
                        icon: const Icon(
                          Icons.key,
                          color: Colors.white,
                        ),
                        controller: passController,
                        labelText: 'Contraseña',
                        isPass: true,
                      ),
                      const SizedBox(height: 50),
                      loading
                          ? const CircularProgressIndicator()
                          : PrymaryButton(
                              text: 'Ingresar',
                              function: () {
                                validation();
                              },
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  validation() async {
    if (emailController.text.isEmpty || passController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(showSnack('Completa todos los campos', 3));
    } else {
      setState(() => loading = true);
      bool loginSuccess = await Endpoints()
          .login(pass: passController.text, user: emailController.text);
      if (loginSuccess) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        setState(() => loading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(showSnack('Credenciales incorrectos', 3));
      }
    }
  }

  showSnack(
    String text,
    int duration,
  ) {
    return SnackBar(
      duration: Duration(seconds: duration),
      content: Text(text),
      backgroundColor: Colors.red[400],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
