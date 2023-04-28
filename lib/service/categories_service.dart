import 'package:dio/dio.dart';
import 'package:tcc_impacta/service/categories_dto.dart';

class CategorieService {
  final dio = Dio();

  static final CategorieService _instance = CategorieService._internal();

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory CategorieService() {
    return _instance;
  }

  CategorieService._internal() {
    // initialization logic
  }

  Map<String, dynamic> header = {};

  Future<void> create(Data data, double maxValue) async {
    try {
      var category = CategoryDto(data: []);

      await dio.post(
        'http://0.0.0.0:80/api/categories',
        options: Options(headers: header),
        data: {"title": data.title, "maxValue": maxValue, "debits": []},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<CategoryDto> get(String jwt) async {
    header = {"Accept": "application/json", "Authorization": "Bearer $jwt"};
    try {
      var category = CategoryDto(data: []);

      // await Future.delayed(Duration(seconds: 2));
      final response = await dio.get('http://0.0.0.0:80/api/categories',
          options: Options(headers: header)
          // data: {"email": email, "password": password}

          );

      return CategoryDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
