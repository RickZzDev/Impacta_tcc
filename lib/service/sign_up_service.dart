import 'package:dio/dio.dart';

class SignUpService {
  final dio = Dio();

  Future<void> register(
      String name, String email, String password, double montlhyIncome) async {
    try {
      final response = await dio.post('http://0.0.0.0:80/api/users', data: {
        "name": name,
        "email": email,
        "password": password,
        "monthly_income": montlhyIncome
      });
    } catch (e) {
      rethrow;
    }
  }
}
