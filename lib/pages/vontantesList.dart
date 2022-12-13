import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:votantes/appConfig.dart';
import 'package:votantes/pages/widgets/appbar.dart';
import 'package:votantes/pages/widgets/backImage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class VotantesList extends StatefulWidget {
  const VotantesList({super.key});

  @override
  State<VotantesList> createState() => _VotantesListState();
}

class _VotantesListState extends State<VotantesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const PreferredSize(preferredSize: Size(0, 60), child: MyAppbar()),
      body: Stack(children: [
        const BackgroundImage(),
        SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Lista de Votantes',
                  style: AppCongig().prymaryStrongTextStyle,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: const Text(
                          'Nombre',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )),
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: const Text(
                          'Cédula',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )),
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: const Text(
                          'Contactos',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ))
                  ],
                ),
                const SizedBox(height: 5),
                for (var i = 0; i < 20; i++)
                  Column(
                    children: [
                      const Divider(color: Colors.white),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: const Text(
                                'Nombre apellido Apellido Apell',
                                style: TextStyle(color: Colors.white),
                              )),
                          Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                '5591945',
                                style: TextStyle(color: Colors.white),
                              )),
                          Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.whatsapp,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      _launchWhatsapp();
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      _launchCaller();
                                    },
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  _launchCaller() async {
    const url = "tel:0982763732";
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchWhatsapp() async {
    try {
      String text = "Hello World !! Hey There";
      String url = "https://wa.me/595984813734?text=${Uri.encodeFull(text)}";
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("contacto error catch"),
        ),
      );
    }
  }
}
