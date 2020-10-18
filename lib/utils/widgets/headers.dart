import 'dart:convert';
import 'dart:developer';

import 'package:project_boilerplate/utils/constants/strings.dart';

import '../../utils/widgets/widget_models.dart';

// HEADER IN API PROVIDER

Future<Map<String, String>> getHeaders({bool auth = true, bool contentType = true, String contentString = 'application/json', isBasicAuth = false}) async {

  var token = await getPreferences('token', kType: 'string') ?? "";
  var headers;
  if(contentType == true){
    headers = {
      'Content-Type': contentString,
      'Accept': 'application/x.paruh.waktu.v2+json',
      'Accept-Language': 'id',
    };
  }else{
    headers = {
      'Accept': 'application/x.paruh.waktu.v2+json',
      'Accept-Language': 'id',
    };
  }

  if (auth) headers['Authorization'] = "Bearer " + token;

  if (isBasicAuth == true) headers['authorization'] = 'Basic ' + base64Encode(utf8.encode('${Url.usernameContent}:${Url.passwordContent}'));

  log("HEADERS: $headers");

  return headers;
}