import 'package:dio/dio.dart';

Dio createLichessDioClientWith({
  String? accessToken,
  String baseUrl = 'https://lichess.org',
}) {
  final Map<String, String> headers = <String, String>{};

  if (accessToken != null) {
    headers['Authorization'] = 'Bearer $accessToken';
  }

  return Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: headers,
    ),
  );
}
