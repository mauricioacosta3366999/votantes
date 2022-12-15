import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:votantes/appConfig.dart';
import 'package:votantes/pages/widgets/appbar.dart';
import 'package:votantes/pages/widgets/backImage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:votantes/services/endpoints.dart';

class VotantesList extends StatefulWidget {
  const VotantesList({super.key});

  @override
  State<VotantesList> createState() => _VotantesListState();
}

class _VotantesListState extends State<VotantesList> {
  List votantes = [];
  bool loading = true;

  @override
  void initState() {
    Endpoints().getVotantes()?.then((items) => setState(() {
          votantes = items;
          loading = false;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:
          const PreferredSize(preferredSize: Size(0, 60), child: MyAppbar()),
      body: Stack(children: [
        const BackgroundImage(),
        loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: size.width * 0.35,
                          child: const Text(
                            'Nombre',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: size.width * 0.2,
                          child: const Text(
                            'Cédula',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: size.width * 0.15,
                          child: const Text(
                            'Ya voto',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: size.width * 0.3,
                          child: const Text(
                            'Contactos',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    for (var item in votantes)
                      Column(
                        children: [
                          const Divider(color: Colors.white),
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: size.width * 0.35,
                                child: Text(
                                  item.data["nombre"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: size.width * 0.2,
                                child: Text(
                                  item.data["cdi"].toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                              // Container(
                              //   alignment: Alignment.center,
                              //   width: size.width * 0.2,
                              //   child: const Text(
                              //     '0984157824',
                              //     style: TextStyle(color: Colors.white, fontSize: 12),
                              //   ),
                              // ),
                              SizedBox(
                                width: size.width * 0.2,
                                child: item.data["ya_voto"]
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.lightGreenAccent,
                                      )
                                    : const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.whatsapp,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    onPressed: () {
                                      _launchWhatsapp(
                                          item.data["telefono"].toString());
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    onPressed: () {
                                      _launchCaller(
                                          item.data["telefono"].toString());
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              )
      ]),
    );
  }

  _launchCaller(String phone) async {
    var url = "tel:0$phone";
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchWhatsapp(String phone) async {
    try {
      String text = "Esto es un mensaje de prueba";
      String url = "https://wa.me/595$phone?text=${Uri.encodeFull(text)}";
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
