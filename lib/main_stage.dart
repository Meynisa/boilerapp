import 'package:flutter/material.dart';
import 'package:project_boilerplate/utils/constants/strings.dart';
import 'main.dart';
import 'utils/app_config.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.STAGE,
      color: Colors.amber,
      values: FlavorValues(
          baseUrl: Url.baseUrlStage,
          baseSociomileUrl: Url.baseUrlSociomileStage,
          baseSocketUrl: Url.baseUrlSocketStage,
          baseContentUrl: Url.contentTipsUrlStage,
          usernameContent: Url.usernameContentStage,
          passContent: Url.passContentStage
      ));

  mainCommon();
}
