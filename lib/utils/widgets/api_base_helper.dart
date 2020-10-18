import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:async/async.dart';
import 'app_exceptions.dart';
import 'package:http/http.dart' as http;
import '../constants/strings.dart';
import 'headers.dart';
import 'package:path/path.dart';

import 'widget_models.dart';

class ApiBaseHelper {

  Future<dynamic> getDataCss(String url) async {
    log('Api get : $url');
    var responseJson;
    try {
      final response = await http.get(url, headers: await getHeaders(auth: false, isBasicAuth: true));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    print('responseJSON : $responseJson');
    return responseJson;
  }

  Future<dynamic> get(String url, {dynamic param = "", bool isSociomile = false, bool isAuth = true, bool isContentType = false}) async {
    var baseUrl = '${isSociomile ? Url.baseUrlSociomile : Url.baseUrl}';
    var urlString = '$baseUrl$url$param';
    log('Api get : $urlString');
    var responseJson;
    try {
      final response = await http.get(urlString, headers: await getHeaders(auth: isAuth, contentType: isContentType));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    print('responseJSON : $responseJson');
    return responseJson;
  }

  Future<dynamic> post(String url, dynamic body, {bool isSociomile = false, bool isAuth = true, bool isContentType = true, String contentString = 'application/json'}) async {
    var baseUrl = '${isSociomile ? Url.baseUrlSociomile : Url.baseUrl}';
    var urlString = '$baseUrl$url';
    var responseJson;
    try {
      final response = await http.post(urlString, body: body, headers: await getHeaders(auth: isAuth, contentType: isContentType, contentString: contentString));
      log('Api post : $urlString, body: $body');
//      print('RESPONSE: $response');
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No Internet Connection');
      throw FetchDataException('No Internet Connection');
    }
    print('responseJSON : $responseJson');
    return responseJson;
  }

  Future<dynamic> put(String url, dynamic body, {bool isSociomile = false, String contentString = 'application/json'}) async {
    var baseUrl = '${isSociomile ? Url.baseUrlSociomile : Url.baseUrl}';
    var urlString = '$baseUrl$url';
    print('Api Put, url: $urlString, body: $body');
    var responseJson;
    try {
      final response = await http.put(urlString, body: body, headers: await getHeaders(contentString: contentString));
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No Internet Connection');
      throw FetchDataException('No Internet Connection');
    }
    print('api put');
    print("API RESPONSE: " + responseJson.toString());
    return responseJson;
  }

  Future<dynamic> delete(String url, {bool isSociomile = false}) async {
    var baseUrl = '${isSociomile ? Url.baseUrlSociomile : Url.baseUrl}';
    var urlString = '$baseUrl$url';
    print('Api delete, url: $urlString');
    var responseJson;
    try {
      final response = await http.delete(urlString);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No Internet Connection');
      throw FetchDataException('No Internet Connection');
    }
    print('api delete');
    return responseJson;
  }

  Future<dynamic> upload(String url, File imageFile , {bool isSociomile = false, String type = ""}) async {

    var baseUrl = '${isSociomile ? Url.baseUrlSociomile : Url.baseUrl}';
    var urlString = '$baseUrl$url';

    // open a bytestream
    var stream = new http.ByteStream(Stream.castFrom(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse('$urlString');
    print('URL: $uri');

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('filename', stream, length, filename: basename(imageFile.path));

    var token = await getPreferences('token', kType: 'string') ?? "";

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/x.paruh.waktu.v2+json',
      'Accept-Language': 'id',
      'Authorization': "Bearer $token",
    };

    request.headers.addAll(headers);
    // add file to multipart
    request.files.add(multipartFile);

    // send
    http.StreamedResponse response = await request.send().then((response){
      if(response.statusCode == 201){
        print(response.statusCode);
        print('masuk sini');

        //     listen for response
        response.stream.transform(utf8.decoder).listen((value){
          var responseJson;
          print('Upload Response: $value');
          responseJson = json.decode(value);
          print('json: ${responseJson["data"]["attributes"]["url"]}');
          if(type == "ktp"){
            savePreferences('idCard', stringValue: '${responseJson["data"]["id"]}');
            print('idCard: ${responseJson["data"]["id"]}');
          }else if(type == "selfi_ktp"){
            savePreferences('idCardSelfie', stringValue: '${responseJson["data"]["id"]}');
            print('idCardSelfie: ${responseJson["data"]["id"]}');
          }else if(type == "npwp"){
            savePreferences('idCardNpwp', stringValue: '${responseJson["data"]["id"]}');
            print('idCardNpwp: ${responseJson["data"]["id"]}');
          }else{
            savePreferences('urlProfile', stringValue: '${responseJson["data"]["attributes"]["url"]}');
            print('urlProfile: ${responseJson["data"]["attributes"]["url"]}');
          }
          return responseJson;
        });
      }
      return null;
    });
    return response;
  }
}

dynamic _returnResponse(http.Response response) {
  print('Response: ${response.body.toString()}');
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 201:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
      throw json.decode(response.body.toString())["status_code"];
    case 403:
      throw InvalidInputException(json.decode(response.body.toString())["message"]);
    case 422:
      // String msg = json.decode(response.body)['errors']['old_password'][0];
      String msg = json.decode(response.body.toString())["errors"]["old_password"] == null 
      ? json.decode(response.body.toString())["errors"]["user"] == null 
      ? json.decode(response.body.toString())["errors"]["shift"] == null 
      ? json.decode(response.body.toString())["errors"]["username"] == null 
      ? json.decode(response.body.toString())["errors"]["message_id"][0] 
      // ? json.decode(response.body.toString())["errors"]["old_password"] == null 
      : json.decode(response.body.toString())["errors"]["username"][0] 
      : json.decode(response.body.toString())["errors"]["shift"][0] 
      : json.decode(response.body.toString())["errors"]["user"][0]
      : json.decode(response.body.toString())["errors"]["old_password"][0];
      print('ERROR msg: $msg');
      throw InvalidInputException(msg);
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
      var responseJson = json.decode(response.body.toString());
      throw InvalidInputException(responseJson['message']);
    default:
      throw FetchDataException('Error occured while Communication with server with status code: ${response.statusCode}');
  }
}
