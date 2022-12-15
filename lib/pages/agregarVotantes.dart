import 'package:flutter/material.dart';
import 'package:votantes/appConfig.dart';
import 'package:votantes/models/cdiDetallesModel.dart';
import 'package:votantes/pages/cdiData.dart';
import 'package:votantes/pages/widgets/appbar.dart';
import 'package:votantes/pages/widgets/backImage.dart';
import 'package:votantes/pages/widgets/prymaryButton.dart';
import 'package:votantes/pages/widgets/textField.dart';
import 'package:votantes/services/endpoints.dart';

class AgregarVotantes extends StatefulWidget {
  final bool onlySearchCdi;
  const AgregarVotantes({super.key, required this.onlySearchCdi});
  @override
  State<AgregarVotantes> createState() => _AgregarVotantesState();
}

class _AgregarVotantesState extends State<AgregarVotantes> {
  final cdiController = TextEditingController();
  final phoneController = TextEditingController();
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
                    widget.onlySearchCdi ? 'Buscar cédula' : 'Agregar Votantes',
                    style: AppCongig().prymaryStrongTextStyle,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Text(
                    widget.onlySearchCdi
                        ? 'Registrá el votó de la persona'
                        : 'Agregá a tu lista de votantes',
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
                  widget.onlySearchCdi
                      ? Container()
                      : MyTextField(
                          icon: const Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.number,
                          controller: phoneController,
                          labelText: "Número de teléfono"),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  loading
                      ? const CircularProgressIndicator()
                      : PrymaryButton(
                          text: 'Buscar datos',
                          function: () async {
                            dataSearch();
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

  dataSearch() async {
    if (cdiController.text.isEmpty || cdiController.text.length != 7) {
      ScaffoldMessenger.of(context)
          .showSnackBar(showSnack('Agregá un número de cédula', 3));
    } else {
      setState(() => loading = true);
      CdiDetallesModel cdiDetalles = await Endpoints()
          .searchByCi(cdi: cdiController.text, phone: phoneController.text);
      if (cdiDetalles.ci != null) {
        cdiDetalles.celular = phoneController.text;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CdiData(
                      cdiDetalles: cdiDetalles,
                      voteRegister: widget.onlySearchCdi ? true : false,
                    )));
        setState(() => loading = false);
      } else {
        setState(() => loading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(showSnack('No se encontró en el padrón', 3));
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
