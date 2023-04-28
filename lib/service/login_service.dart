import 'package:dio/dio.dart';

class LoginService {
  final dio = Dio();

  Future<String> login(String email, String password) async {
    try {
      final response = await dio.post('http://0.0.0.0:80/api/login',
          data: {"email": email, "password": password});
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
