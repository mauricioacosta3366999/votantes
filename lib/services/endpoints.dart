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
      await storage.write(key: 'userId', value: response.data["record"]['id']);
      await storage.write(
          key: 'userName', value: response.data['record']['name']);
      await storage.write(
          key: 'userType', value: response.data['record']['type']);
      return true;
    } catch (e) {
      return false;
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
        final body = <String, dynamic>{
          "ci": model.ci,
          "apellidos": model.apellidos,
          "nombres": model.nombres,
          "celular": phone,
        };
        final newData =
            await pb.collection('empadronados').update(model.id!, body: body);
        return model;
      }
    } catch (e) {
      print(e);
      return CdiDetallesModel();
    }
  }

  crearVotante(
      {required String empadronadoId,
      String? memberId,
      String? seecionaleroId}) async {
    String? value = await storage.read(key: 'token');
    app.options.headers["Authorization"] = "Bearer $value";
    var url = '$baseUrl/api/collections/votantes/records';
    try {
      var res = await app.post(url, data: {
        "empadronado": empadronadoId,
        "ya_voto": false,
        "miembro_que_registro": memberId,
        "seccionalero_que_registro": seecionaleroId
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  editarVoto(
      {required String empadronadoId,
      String? memberId,
      String? seecionaleroId}) async {
    String? value = await storage.read(key: 'token');
    app.options.headers["Authorization"] = "Bearer $value";
    try {
      final record = await pb.collection('votantes').getFirstListItem(
            'empadronado="$empadronadoId"',
            expand: 'relField1,relField2.subRelField',
          );
      var url = '$baseUrl/api/collections/votantes/records/${record.id}';
      var res = await app.patch(url, data: {
        "empadronado": empadronadoId,
        "ya_voto": true,
        "miembro_que_registro": memberId,
        "seccionalero_que_registro": seecionaleroId
      });
      print(res);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> memberCreate(
      {required String ci, required String pass}) async {
    String? value = await storage.read(key: 'token');
    app.options.headers['content-Type'] = 'application/json';
    app.options.headers["Authorization"] = "Bearer $value";
    try {
      var userId = await storage.read(key: "userId");
      final seccionalero =
          await pb.collection('seccionaleros').getFirstListItem(
                'usuario="$userId"',
                expand: 'relField1,relField2.subRelField',
              );
      final userDto = <String, dynamic>{
        "username": ci,
        "password": pass,
        "passwordConfirm": pass,
        "type": "miembro"
      };
      final user = await pb.collection('users').create(body: userDto);
      final memberDto = <String, dynamic>{
        "seccionalero": seccionalero.id,
        "ci": ci,
        "usuario": user.id,
        "celular": 1234567,
        "nombres": "test test",
        "apellidos": "test test",
      };

      await pb.collection('miembros').create(body: memberDto);
      return "Miembro creado exitosamente";
    } catch (e) {
      throw ClientException();
    }
  }

  Future<List>? getVotantes() async {
    try {
      var userId = await storage.read(key: "userId");
      var userType = await storage.read(key: 'userType');
      var resultList = [];

      if(userType == "seccionalero") {
        final seccionalero = await pb.collection('seccionaleros').getFirstListItem(
          'usuario="$userId"',
          expand: 'relField1,relField2.subRelField',
        );
        resultList = (await pb.collection('votantes').getList(
          filter: 'seccionalero_que_registro = "${seccionalero.id}"',
          expand: "empadronado",
        )).items;
      } else {
        final miembro = await pb.collection('miembros').getFirstListItem(
          'usuario="$userId"',
          expand: 'relField1,relField2.subRelField',
        );
        resultList = (await pb.collection('votantes').getList(
          filter: 'miembro_que_registro = "${miembro.id}"',
          expand: "empadronado",
        )).items;
      }

      resultList = await pb.collection('votantes').getFullList(
        batch: 200,
        sort: '-created',
        expand: "empadronado, empadronado.nombres, empadronado.apellidos, empadronados, empadronados.nombres",
      );

      return resultList;
    } catch(e) {
      print(e);
    }
    return [];
  }
}
