import 'dart:async';
import 'dart:convert';
import 'package:project_boilerplate/utils/widgets/api_repository.dart';
import 'package:project_boilerplate/auth/data/login_response.dart';
import 'package:project_boilerplate/utils/widgets/api_response.dart';
import 'package:project_boilerplate/utils/widgets/validators.dart';
import 'package:project_boilerplate/utils/widgets/widget_models.dart';
import 'package:rxdart/rxdart.dart';

class BlocRegister extends Validators {
  final _name = BehaviorSubject<String>.seeded('');
  final _email = BehaviorSubject<String>.seeded('');
  final _phone = BehaviorSubject<String>.seeded('');
  final _password = BehaviorSubject<String>.seeded('');

  final _apiRepository = ApiRepository();

  //Add data to stream
  Stream<String> get name => _name.stream.transform(validateName);
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get phone => _phone.stream.transform(validatePhone);
  Stream<String> get password => _password.stream.transform(validatePassword);

  final _seen = BehaviorSubject<bool>.seeded(true);
  StreamSink<bool> get seenSink => _seen.sink;
  Stream<bool> get seenStream => _seen.stream;

  final _isChecked = BehaviorSubject<bool>.seeded(false);
  StreamSink<bool> get isCheckedSink => _isChecked.sink;
  Stream<bool> get isCheckedStream => _isChecked.stream;

  Stream<bool> get submitValid =>
      CombineLatestStream.combine5(name, email, phone, password, isCheckedStream.transform(validateCheckbox), (a, b, c, d, e) => true);

  StreamController _registerController;

  StreamSink<ApiResponse<dynamic>> get registerSink =>
      _registerController.sink;

  Stream<ApiResponse<dynamic>> get registerStream =>
      _registerController.stream;

  //Change data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeName => _name.sink.add;
  Function(String) get changePhone => _phone.sink.add;

  BlocRegister(){
    _registerController = StreamController<ApiResponse<dynamic>>();
  }

  submit() async{
    final validEmail = _email.value;
    final validPassword = _password.value;
    final validName = _name.value;
    final validPhone = _phone.value;

    Map<String, dynamic> data = {};
    data["full_name"] = validName;
    data["handphone"] = validPhone;
    data["email"] = validEmail;
    data["password"] = validPassword;
    data["type"] = "agent";
    data["callback"] = "https://app-pw.s45.in/#/verification";

    print('DATA: $data');

    registerSink.add(ApiResponse.loading('Loading'));
    try{
      var registerResponse = await _apiRepository.registerUser(jsonEncode(data));
      registerSink.add(ApiResponse.completed(registerResponse));
    }catch (e){
      print('ERROR: ${e.toString()}');
      registerSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _seen.close();
    _isChecked.close();
    _email.close();
    _password.close();
    _name.close();
    _phone.close();
    _registerController.close();
  }
}