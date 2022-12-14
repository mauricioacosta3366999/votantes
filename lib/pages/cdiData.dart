import 'package:flutter/material.dart';
import 'package:votantes/appConfig.dart';
import 'package:votantes/models/cdiDetallesModel.dart';
import 'package:votantes/pages/widgets/appbar.dart';
import 'package:votantes/pages/widgets/backImage.dart';
import 'package:votantes/pages/widgets/prymaryButton.dart';

class CdiData extends StatefulWidget {
  final CdiDetallesModel cdiDetalles;
  const CdiData({super.key, required this.cdiDetalles});

  @override
  State<CdiData> createState() => _CdiDataState();
}

class _CdiDataState extends State<CdiData> {
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
              Text(
                'Votante:',
                style: AppCongig().prymaryStrongTextStyle,
              ),
              const SizedBox(height: 50),
              Text(
                'Cédula:',
                style: AppCongig().prymaryStrongTextStyle,
              ),
              Text(
                widget.cdiDetalles.ci.toString(),
                style: AppCongig().prymaryTextStyle,
              ),
              const SizedBox(height: 20),
              Text(
                'Nombre:',
                style: AppCongig().prymaryStrongTextStyle,
              ),
              Text(
                '${widget.cdiDetalles.nombres} ${widget.cdiDetalles.nombres}',
                style: AppCongig().prymaryTextStyle,
              ),
              const SizedBox(height: 20),
              Text(
                'Teléfono:',
                style: AppCongig().prymaryStrongTextStyle,
              ),
              Text(
                widget.cdiDetalles.celular!,
                style: AppCongig().prymaryTextStyle,
              ),
              const SizedBox(height: 20),
              Text(
                'Sexo:',
                style: AppCongig().prymaryStrongTextStyle,
              ),
              Text(
                widget.cdiDetalles.sexo == 'F' ? 'Femenino' : 'Masculino',
                style: AppCongig().prymaryTextStyle,
              ),
              const SizedBox(height: 50),
              PrymaryButton(
                text: 'Agregar votante',
                function: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                      showSnack('Vontante registrado exitosamente.', 3));
                },
              )
            ],
          ),
        )
      ]),
    );
  }

  showSnack(
    String text,
    int duration,
  ) {
    return SnackBar(
      duration: Duration(seconds: duration),
      content: Text(text),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
