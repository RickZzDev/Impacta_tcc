import 'package:dio/dio.dart';

class SignUpService {
  final dio = Dio();

  Future<void> register(String name, String email, String password) async {
    try {
      final response = await dio.post('http://10.0.2.2:80/api/users',
          data: {"name": name, "email": email, "password": password});
    } catch (e) {
      rethrow;
    }
  }
}
