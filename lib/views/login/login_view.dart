import 'package:dashboard/services/session_manager/session_manager.dart';
import 'package:dashboard/views/login/login_viewmodel.dart';
import 'package:dashboard/views/login/onboarding_register.dart';
import 'package:dashboard/views/login/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// import 'package:openid_client/openid_client.dart';
import 'package:openid_client/openid_client_io.dart';
// import 'package:openid_client/openid_client_browser.dart';

import 'package:url_launcher/url_launcher.dart';

// FlutterAppAuth appAuth = FlutterAppAuth();
String zitadelClientID = "99929852957813481@kasparundcore";
String zitadelRedirectURI = "kasparund://login-callback";

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  SessionManager prefs = SessionManager();

  bool isBusy = false;
  bool isLoggedIn = false;
  bool isRegistered = false;
  String errorMessageLogin = '';
  String errorMessageRegister = '';
  String errorMessageLoadData = '';
  String name = '';
  String prefUsername = '';
  String exp = '';
  String picture = "";
  late User user;
  late OnboardingRegister registeredUser;
  // late AuthorizationTokenResponse result;

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessageLogin = '';
    });

    // create the client
    // final uri = Uri.dataFromString("https://issuer.zitadel.ch");
    final uri = Uri.parse("https://issuer.zitadel.ch");

    var issuer = await Issuer.discover(uri);
    var client = Client(issuer, zitadelClientID);
    final scopes = ['openid', 'profile', 'offline_access'];

    // create a function to open a browser with an url
    urlLauncher(String url) async {
      if (await canLaunch(url)) {
        await launch(url, forceWebView: false);
      } else {
        throw 'Could not launch $url';
      }
    }

    // create an authenticator
    var authenticator = Authenticator(client,
        scopes: scopes, port: 4000, urlLancher: urlLauncher);

    // get the credential
    // starts the authentication
    var c = await authenticator.authorize(); // this will redirect the browser

    // close the webview when finished
    closeWebView();

    var test = await c.getUserInfo();
    print(test);

    final result = c;
    result.idToken;
    try {
      // final AuthorizationTokenResponse result =
      //     await appAuth.authorizeAndExchangeCode(
      //   AuthorizationTokenRequest(
      //     zitadelClientID,
      //     zitadelRedirectURI,
      //     issuer: 'https://issuer.zitadel.ch',
      //     scopes: ['openid', 'profile', 'offline_access'],
      //   ),
      // ) as AuthorizationTokenResponse;

      Map<String, dynamic> idToken =
          JwtDecoder.decode(result.idToken.toString());
      // final profile = await getUserDetails(result.accessToken);
      print(idToken);
      // print(result.accessToken);

      prefs.setString('id_token', result.idToken.toString());
      // prefs.setString('access_token', result.);
      prefs.setString('refresh_token', result.refreshToken!);

      // await storage.write(key: 'id_token', value: result.idToken);
      // await storage.write(key: 'access_token', value: result.accessToken);
      // await storage.write(key: 'refresh_token', value: result.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken["name"];
        prefUsername = idToken["preferred_username"];
        exp = idToken["exp"].toString();

        picture =
            "https://www.pavilionweb.com/wp-content/uploads/2017/03/man-300x300.png";
      });
    } catch (e, _) {
      print("error: $e");
      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessageLogin = e.toString();
      });
    }
  }

  Future<void> registerAction() async {
    setState(() {
      isBusy = true;
      errorMessageRegister = '';
    });
    try {
      String url = 'http://10.0.2.2:57346/api/v1/onboarding';
      Uri uri = Uri.parse(url);

      OnboardingRegister request = OnboardingRegister(
        firstName: "TestFirstName",
        lastName: "TestLastName",
        email: "Test@email.ch",
        phone: "+41765763407",
        password: "Testtest1234!",
      );

      // TODO: Change to APIService
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          isRegistered = true;
          registeredUser = request;
          isBusy = false;
        });
      } else {
        setState(() {
          isRegistered = false;
          errorMessageRegister = "Could not register User";
          isBusy = false;
        });
      }
    } catch (e, _) {
      print("error: $e");
      setState(() {
        isBusy = false;
        isRegistered = false;
        errorMessageRegister = e.toString();
      });
    }
  }

  Future<void> loadDataAction() async {
    setState(() {
      isBusy = true;
      errorMessageLoadData = '';
    });

    try {
      // String? accessToken = await storage.read(key: "access_token");
      String? accessToken = await prefs.getString("access_token");

      String url =
          'http://10.0.2.2:8080/api/v1/user/e044de5f-8aac-44c7-95c1-bd0603e8bc43';
      Uri uri = Uri.parse(url);
      await Future.delayed(const Duration(seconds: 2), () {});

      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        User jsonResponse = User.fromJson(json.decode(response.body));

        setState(() {
          user = jsonResponse;
          isBusy = false;
        });
      } else {
        setState(() {
          errorMessageLoadData = "Could not load data";
          isBusy = false;
        });
      }
    } catch (e, _) {
      print("error: $e");
      setState(() {
        isBusy = false;
        errorMessageLoadData = e.toString();
      });
    }
  }

  Future<void> logoutAction() async {
    // await storage.delete(key: 'refresh_token');
    await prefs.remove('refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Stack(
              children: [
                isLoggedIn
                    ? Profile(logoutAction, loadDataAction,
                        errorMessageLoadData, name, picture)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Register(registerAction, errorMessageRegister),
                                Login(loginAction, errorMessageLogin),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            width: double.infinity,
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pushReplacementNamed(
                                          context, '/InAppWebView'),
                                  child: Text("InAppWebView"),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pushReplacementNamed(
                                          context, '/InAppBrowser'),
                                  child: Text("InAppBrowser"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                if (isBusy) LoadingOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  final Future<void> Function() logoutAction;
  final Future<void> Function() loadDataAction;
  final String error;
  // final User user;
  final String name;
  final String picture;

  const Profile(this.logoutAction, this.loadDataAction, this.error, this.name,
      this.picture,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 4),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(picture),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Name: $name'),
        const SizedBox(
          height: 48,
          width: double.infinity,
        ),
        ElevatedButton(
          onPressed: () async {
            await loadDataAction();
          },
          child: const Text('Load data from server'),
        ),
        if (error != "") Text(error),
        const SizedBox(height: 16),
        // if (user != null) Text(user.profile.dateOfBirth),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            await logoutAction();
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}

/// -----------------------------------
///            Login Widget
/// -----------------------------------
class Login extends StatelessWidget {
  final Future<void> Function() loginAction;
  final String error;

  const Login(this.loginAction, this.error, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            await loginAction();
          },
          child: const Text('Login'),
        ),
        if (error != "") Text(error),
      ],
    );
  }
}

class Register extends StatelessWidget {
  final Future<void> Function() registerAction;
  final String error;

  const Register(this.registerAction, this.error, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            await registerAction();
          },
          child: const Text('Register'),
        ),
        if (error != "") Text(error),
      ],
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.3,
          child: const ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Center(
          child: const CircularProgressIndicator(),
        ),
      ],
    );
  }
}
