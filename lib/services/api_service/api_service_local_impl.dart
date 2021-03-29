import 'package:dashboard/services/api_service/api_request.dart';
import 'package:dashboard/services/api_service/api_service.dart';

class APIServiceLocalImpl implements APIService {
  @override
  Future<bool> isAPIavailable() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<dynamic> get(APIRequest apiRequest) async {
    if (apiRequest.uri == "hostname") {
      return {"hostname": "local-host (mobile)"};
    } else if (apiRequest.uri == "auth/login") {
      return {
        "token":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MTMyNDY0NDgsInVzZXJpZCI6IjNlODM3ZGUxLTQ0MDEtNGU4OS04MDM2LTNhNTRjOTJjODcxYSJ9.Fq49k3SngpgPQDuAphzan_5cd72WqGWB6or9-xY6DTA",
        "userId": "3e837de1-4401-4e89-8036-3a54c92c871a"
      };
    } else {
      return null;
    }
  }

  @override
  Future<dynamic> post(APIRequest apiRequest) async {
    return null;
  }

  @override
  Future delete(APIRequest apiRequest) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future patch(APIRequest apiRequest) {
    // TODO: implement patch
    throw UnimplementedError();
  }

  @override
  Future update(APIRequest apiRequest) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
