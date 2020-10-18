import 'dart:io';
import 'dart:typed_data';
import 'package:project_boilerplate/auth/data/user_response.dart';
import 'package:project_boilerplate/utils/constants/strings.dart';
import 'package:project_boilerplate/utils/widgets/api_base_helper.dart';
import 'app_exceptions.dart';
import 'package:http/http.dart' as http;
import '../constants/strings.dart';
import 'headers.dart';

class ApiRepository{

  ApiBaseHelper _helper = ApiBaseHelper();

  Future login (body) => _helper.post(Url.login, body);

  Future forgotPassword(body) async{
    final response = await _helper.post(Url.forgotPassword, body, isAuth: false);
    print('RESPONSE FORGOT PASS: $response');
    return response;
  }

  Future<UserResponse> fetchUserData() async{
    final response = await _helper.get(Url.userProfile, param: "");
    print('RESPONSE PROFILE: $response');
    return UserResponse.fromJson(response);
  }

  Future registerUser(body) async{
    final response = await _helper.post(Url.register, body, isAuth: false);
    print('RESPONSE REGISTER: $response');
    return response;
  }

  Future changePassword(body) async {
    final response = await _helper.post(Url.changePassword, body);
    return response;
  }

  Future<Uint8List> getImage(String fileId) async {
    var url = Url.baseUrl + Url.uploadImg + fileId;
    print('url: $url');
    Uint8List responseJson;
    try {
      final response = await http.get(url, headers: await getHeaders(auth: true, contentType: true));
      responseJson = response.bodyBytes;
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    print('responseJSON : $responseJson');
    return responseJson;
  }

  Future saveAccount(body) async {
    final response = await _helper.post(Url.bankUser, body);
    return response;
  }

  Future<List<dynamic>> fetchingDataTips() async {
    List<dynamic> response = await _helper.getDataCss(Url.contentTipsUrl);
    print('Tips Response: $response');
    return response;
  }

  Future<dynamic> fetchingImage(String url) async {
    final response = await _helper.getDataCss(url);
    String res = response["guid"]["rendered"];
    print('IMAGE_UL: $res');
    return res;
  }
}