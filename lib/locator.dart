import 'package:dashboard/services/api_service/api_service.dart';
import 'package:dashboard/services/api_service/api_service_network_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<APIService>(APIServiceNetworkImpl());
  locator.registerSingleton(NavigationService());
}
