import 'package:dashboard/services/api_service/api_request.dart';

abstract class APIService {
  Future<bool> isAPIavailable();

  Future<dynamic> get(APIRequest apiRequest);
  Future<dynamic> post(APIRequest apiRequest);
  Future<dynamic> update(APIRequest apiRequest);
  Future<dynamic> patch(APIRequest apiRequest);
  Future<dynamic> delete(APIRequest apiRequest);
}
