import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:votantes/appConfig.dart';
import 'package:votantes/models/cdiDetallesModel.dart';
import 'package:votantes/pages/agregarVotantes.dart';
import 'package:votantes/pages/home.dart';
import 'package:votantes/pages/widgets/appbar.dart';
import 'package:votantes/pages/widgets/backImage.dart';
import 'package:votantes/pages/widgets/prymaryButton.dart';
import 'package:votantes/services/endpoints.dart';

class CdiData extends StatefulWidget {
  final CdiDetallesModel cdiDetalles;
  const CdiData({super.key, required this.cdiDetalles});

  @override
  State<CdiData> createState() => _CdiDataState();
}

class _CdiDataState extends State<CdiData> {
  final storage = const FlutterSecureStorage();
  bool loading = false;
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
                '${widget.cdiDetalles.nombres} ${widget.cdiDetalles.apellidos}',
                textAlign: TextAlign.center,
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
              const SizedBox(height: 50),
              loading
                  ? const CircularProgressIndicator()
                  : PrymaryButton(
                      text: 'Agregar votante',
                      function: () {
                        addVot();
                      },
                    )
            ],
          ),
        )
      ]),
    );
  }

  addVot() async {
    setState(() => loading = true);
    final pb = PocketBase('https://pocketbase-production-a3d9.up.railway.app');
    bool res = false;
    var userType = await storage.read(key: "userType");
    var userId = await storage.read(key: "userId");
    if (userType == 'miembro') {
      try {
        final miembro = await pb.collection('miembros').getFirstListItem(
              'usuario="$userId"',
              expand: 'relField1,relField2.subRelField',
            );
        res = await Endpoints().crearVotante(
            empadronadoId: widget.cdiDetalles.id!,
            memberId: miembro.id,
            seecionaleroId: miembro.data['seccionalero']);
        setState(() => loading = false);
      } catch (e) {
        setState(() => loading = false);
        print(e);
      }
    } else {
      try {
        final seccionalero =
            await pb.collection('seccionaleros').getFirstListItem(
                  'usuario="$userId"',
                  expand: 'relField1,relField2.subRelField',
                );
        res = await Endpoints().crearVotante(
            empadronadoId: widget.cdiDetalles.id!,
            seecionaleroId: seccionalero.id);
        setState(() => loading = false);
      } catch (e) {
        setState(() => loading = false);
        print(e);
      }
    }
    Navigator.pop(context);
    setState(() => loading = false);
    if (res) {
      ScaffoldMessenger.of(context).showSnackBar(
          showSnack('Vontante registrado exitosamente.', 3, true));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(showSnack('Esta persona ya fue registrada.', 3, false));
    }
  }

  showSnack(
    String text,
    int duration,
    bool isOk,
  ) {
    return SnackBar(
      duration: Duration(seconds: duration),
      content: Text(text),
      backgroundColor: isOk ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
