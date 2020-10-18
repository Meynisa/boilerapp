import 'dart:async';
import 'dart:convert';
import 'package:project_boilerplate/utils/widgets/api_repository.dart';
import 'package:project_boilerplate/auth/data/login_response.dart';
import 'package:project_boilerplate/utils/widgets/api_response.dart';
import 'package:project_boilerplate/utils/widgets/validators.dart';
import 'package:project_boilerplate/utils/widgets/widget_models.dart';
import 'package:rxdart/rxdart.dart';

class BlocLogin extends Validators {
  final _email = BehaviorSubject<String>.seeded('');
  final _password = BehaviorSubject<String>.seeded('');
  final _seen = BehaviorSubject<bool>.seeded(true);

  final _apiRepository = ApiRepository();

  //Add data to stream
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  StreamSink<bool> get seenSink => _seen.sink;
  Stream<bool> get seenStream => _seen.stream;

  Stream<bool> get submitValid =>
      CombineLatestStream.combine2(email, password, (e, p) => true);

  StreamController _loginListController;

  StreamSink<ApiResponse<LoginResponse>> get loginListSink =>
      _loginListController.sink;

  Stream<ApiResponse<LoginResponse>> get loginListStream =>
      _loginListController.stream;

  //Change data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;

  StreamController<ApiResponse<dynamic>> _forgotPassController =
  new BehaviorSubject();
  StreamSink<ApiResponse<dynamic>> get forgotPassSink =>
      _forgotPassController.sink;
  Stream<ApiResponse<dynamic>> get forgotPassStream =>
      _forgotPassController.stream;

  BlocLogin() {
    _loginListController = StreamController<ApiResponse<LoginResponse>>();
  }

  submit() async {
    final validEmail = _email.value;
    final validPassword = _password.value;

    print('Email: $validEmail');
    Map<String, dynamic> data = {};
    data["username"] = validEmail;
    data["password"] = validPassword;
    data["remember_me"] = true;
    data['scopes'] = 'agent';

    print('DATA: $data');

    loginListSink.add(ApiResponse.loading('Loading'));
    try {
      var loginResponse = await _apiRepository.login(jsonEncode(data));
      loginListSink
          .add(ApiResponse.completed(LoginResponse.fromJson(loginResponse)));
      savePreferences('token',
          stringValue: LoginResponse.fromJson(loginResponse).accessToken);
    } catch (e) {
      print(
          'ERROR_LOGIN: ${e.toString()}, ${e.toString() == "Error During Communication: No Internet Connection" ? 'hey' : 'ho'}');
      String err;
      if (e.toString() ==
          "Error During Communication: No Internet Connection") {
        err = "Koneksi internet tidak tesedia";
      } else if (e.toString() ==
          "The provided authorization grant (e.g., authorization code, resource owner credentials) or refresh token is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client.") {
        err = "Kata sandi yang kamu masukkan tidak valid";
      } else {
        err = e.toString();
      }
      loginListSink.add(ApiResponse.error(err));
    }
    print('$validEmail, $validPassword');
  }


  postForgotPassword(String email) async{
    Map<String, dynamic> data = {};
    data["email"] = email;
    data["callback"] = "https://app-pw.s45.in/%23/forgot-password";

    print('DATA: $data');

    forgotPassSink.add(ApiResponse.loading('Loading'));
    try{
      var forgotPassResponse = await _apiRepository.forgotPassword(jsonEncode(data));
      forgotPassSink.add(ApiResponse.completed(forgotPassResponse));
    }catch (e){
      print('ERROR: ${e.toString()}');
      forgotPassSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _seen.close();
    _email.close();
    _password.close();
    _loginListController.close();
    _forgotPassController.close();
  }
}
