import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:votantes/models/cdiDetallesModel.dart';

class Endpoints {
  final app = Dio();
  final storage = const FlutterSecureStorage();
  final baseUrl = 'https://pocketbase-production-a3d9.up.railway.app';
  final pb = PocketBase('https://pocketbase-production-a3d9.up.railway.app');

  Future login({required String user, required String pass}) async {
    var url = '$baseUrl/api/collections/users/auth-with-password';
    try {
      var response =
          await app.post(url, data: {"identity": user, "password": pass});
      await storage.write(key: 'token', value: response.data['token']);
      await storage.write(key: 'id', value: response.data['id']);
      await storage.write(
          key: 'userName', value: response.data['record']['name']);
      await storage.write(
          key: 'userType', value: response.data['record']['type']);
      return true;
    } catch (e) {
      return false;
    }
  }

  memberCreate({required String ci, required String pass}) async {
    var url = '$baseUrl/api/collections/miembros/records';
    try {
      var response = await app.post(url, data: {
        'username': ci,
        'password': pass,
        'passwordConfirm': pass,
        'type': 'miembro',
        'email': 'test@gmail.com',
        'emailVisibility': true,
        'apellidos': 'test ap',
        'celular': '000000000',
        'ci': '0000000',
        'nombres': 'test nom',
        'code': '1'
      });
      print(response);
    } catch (e) {
      print(e);
    }
  }

  searchByCi({required String cdi, String? phone}) async {
    String? value = await storage.read(key: 'token');
    app.options.headers['content-Type'] = 'application/json';
    app.options.headers["Authorization"] = "Bearer $value";
    try {
      var url =
          "https://pocketbase-production-a3d9.up.railway.app/api/collections/empadronados/records?filter=ci=$cdi";
      var response = await app.get(url);
      if (response.data['items'].isEmpty) {
//consultar en el endpoint del gobierno
        var responses = await app.post(
          'https://www.anr.org.py/padron/api.php',
          data: {"cpt": "-", "cedula": cdi},
        );
        var decoder = json.decode(responses.data);
        CdiDetallesModel model = CdiDetallesModel(
          apellidos: decoder['data'][0]['apellido'],
          nombres: decoder['data'][0]['nombre'],
          ci: int.parse(cdi),
          celular: phone,
        );
//agregar persona al padrón
        try {
          final body = <String, dynamic>{
            "ci": model.ci,
            "apellidos": model.apellidos,
            "nombres": model.nombres,
            "celular": phone,
          };
          final newData =
              await pb.collection('empadronados').create(body: body);
        } catch (e) {
          print(e);
        }
        return model;
      } else {
        CdiDetallesModel model =
            CdiDetallesModel.fromJson(response.data['items'][0]);
        return model;
      }
    } catch (e) {
      print(e);
      return CdiDetallesModel();
    }
  }

  agregarVotante() async {}
}
