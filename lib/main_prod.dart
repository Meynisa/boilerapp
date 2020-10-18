import 'package:flutter/material.dart';
import 'package:project_boilerplate/utils/constants/strings.dart';
import 'main.dart';
import 'utils/app_config.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.PRODUCTION,
      color: Colors.green,
      values: FlavorValues(
          baseUrl: Url.baseUrlProd,
          baseSociomileUrl: Url.baseUrlSociomileProd,
          baseSocketUrl: Url.baseUrlSocketProd,
          baseContentUrl: Url.contentTipsUrlProd,
          usernameContent: Url.usernameContentProd,
          passContent: Url.passContentProd));

  mainCommon();
}
