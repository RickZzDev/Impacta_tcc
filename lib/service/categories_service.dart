import 'package:dio/dio.dart';
import 'package:tcc_impacta/service/categories_dto.dart';

class CategorieService {
  final dio = Dio();

  Future<void> create(String email, String password) async {
    try {
      var category = CategoryDto(data: []);

      await Future.delayed(const Duration(seconds: 2));
      // final response = await dio.post('http://0.0.0.0:80/api/login',
      //     data: {"email": email, "password": password});

    } catch (e) {
      rethrow;
    }
  }

  Future<CategoryDto> get(String jwt) async {
    try {
      var category = CategoryDto(data: []);

      // await Future.delayed(Duration(seconds: 2));
      final response = await dio.get('http://0.0.0.0:80/api/categories',
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $jwt"
          })
          // data: {"email": email, "password": password}

          );

      return CategoryDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
