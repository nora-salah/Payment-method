import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();

  Future<Response> post(
      {required String url,
      required body,
      required String token,
      String? contentType,
      Map<String, String>? headers}) async {
    var response = await dio.post(url,
        data: body,
        options: Options(
            contentType: contentType,
            headers: headers ??
                {
                  'Authorization': 'Bearer $token',
                }));
    return response;
  }
}
