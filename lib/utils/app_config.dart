import 'package:flutter/material.dart';
import 'package:project_boilerplate/utils/widgets/strings_utils.dart';

enum Flavor { DEV, STAGE, PRODUCTION }

class FlavorValues {
  final String baseUrl;
  final String baseSociomileUrl;
  final String baseSocketUrl;
  final String baseContentUrl;
  final String usernameContent;
  final String passContent;
  FlavorValues(
      {@required this.baseUrl,
      @required this.baseSociomileUrl,
      @required this.baseSocketUrl,
      @required this.baseContentUrl,
      @required this.usernameContent,
      @required this.passContent});
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final Color color;
  final FlavorValues values;
  static FlavorConfig _instance;

  factory FlavorConfig(
      {@required Flavor flavor,
      Color color: Colors.blue,
      @required FlavorValues values}) {
    _instance ??= FlavorConfig._internal(
        flavor, StringUtils.enumName(flavor.toString()), color, values);
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.name, this.color, this.values);
  static FlavorConfig get instance {
    return _instance;
  }

  static bool isProduction() => _instance.flavor == Flavor.PRODUCTION;
  static bool isDevelopment() => _instance.flavor == Flavor.DEV;
  static bool isStage() => _instance.flavor == Flavor.STAGE;
}
