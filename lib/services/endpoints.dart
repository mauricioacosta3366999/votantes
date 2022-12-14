import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class Endpoints {
  final app = Dio();
  final storage = const FlutterSecureStorage();
  final baseUrl = 'https://pocketbase-production-a3d9.up.railway.app';
  final pb = PocketBase('https://pocketbase-production-a3d9.up.railway.app');

  Future login({required String user, required String pass}) async {
    var url = '$baseUrl/api/collections/users/auth-with-password';
    try {
      var response = await app.post(url, data: {"identity": user, "password": pass});
      await Future.wait([
        storage.write(key: 'token', value: response.data['token']),
        storage.write(key: 'userName', value: response.data['record']['name']),
        storage.write(key: 'userId', value: response.data['record']['id']),
        storage.write(key: 'userType', value: response.data['record']['type']),
      ]);
      return true;
    } catch (e) {
      return false;
    }
  }

  searchByCi({required String cdi}) async {
    try {
      final record = await pb.collection('votantes').getFirstListItem(
            'ci="$cdi"',
            expand: 'relField1,relField2.subRelField',
          );
      print(record);
    } catch (e) {
      print(e);
    }
  }

  Future<String> memberCreate({required String ci, required String pass}) async {
    try{
      var userId = await storage.read(key: "userId");
      final record = await pb.collection('seccionaleros').getFirstListItem(
        'usuario="$userId"',
        expand: 'relField1,relField2.subRelField',
      );
      var seccionaleroId = record.id;
      final userDto = <String, dynamic>{
        "username": ci,
        "password": pass,
        "passwordConfirm": pass,
        "type": "miembro"
      };
      final user = await pb.collection('users').create(body: userDto);
      final memberDto = <String, dynamic>{
        "seccionalero": seccionaleroId,
        "ci": ci,
        "usuario": user.id,
        "celular": 1234567,
        "nombres": "test test",
        "apellidos": "test test",
      };

      var x =  await pb.collection('miembros').create(body: memberDto);

      return "Miembro Creado exitosamente";
    } catch(e) {
      var error = e as ClientException;
      return error.response.toString();
    }
  }
}
