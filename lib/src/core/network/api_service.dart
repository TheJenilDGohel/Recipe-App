import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dio_client.dart';

part 'api_service.g.dart';

class ApiService {
  ApiService(this._dio);

  final Dio _dio;

  /// Performs a GET request and maps the response.
  /// 
  /// [path] The endpoint path.
  /// [queryParameters] Optional query parameters.
  /// [mapper] A function that takes the raw response data and returns the mapped object.
  Future<T> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) mapper,
  }) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    final data = response.data;
    
    return mapper(data);
  }
}

@riverpod
ApiService apiService(ApiServiceRef ref) {
  return ApiService(ref.watch(dioProvider));
}
