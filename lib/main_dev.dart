import 'package:flutter/material.dart';
import 'package:project_boilerplate/utils/constants/strings.dart';
import 'main.dart';
import 'utils/app_config.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.DEV,
      color: Colors.red,
      values: FlavorValues(
          baseUrl: Url.baseUrlDev,
          baseSociomileUrl: Url.baseUrlSociomileDev,
          baseSocketUrl: Url.baseUrlSocketDev,
        baseContentUrl: Url.contentTipsUrlDev,
        usernameContent: Url.usernameContentDev,
        passContent: Url.passContentDev
      ));

  mainCommon();
}
