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
      var response =
          await app.post(url, data: {"identity": user, "password": pass});
      await storage.write(key: 'token', value: response.data['token']);
      await storage.write(
          key: 'userName', value: response.data['record']['name']);
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
}
