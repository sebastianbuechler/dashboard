import 'package:dashboard/core/router/view_routes.dart';
import 'package:dashboard/views/login/login_view.dart';
import 'package:dashboard/views/main/main_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return GetPageRoute(
      settings: RouteSettings(name: settings.name),
      page: () => _generateView(settings),
      fullscreenDialog: _fullScreenDialogs.contains(settings.name),
    );
  }

  static Widget _generateView(RouteSettings settings) {
    switch (settings.name) {

      // Pre-Main Routes
      case ViewRoutes.login:
        return LoginView();

      // Main Routes
      case ViewRoutes.main:
        return MainView();

      default:
        return Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        );
    }
  }

  // Add routes that should behave as fullScreenDialogs
  static final _fullScreenDialogs = [
    // Routes.route_1,
    // Routes.route_2,
  ];
}
