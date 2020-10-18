import 'package:project_boilerplate/utils/constants/strings.dart';

class ValidatorUnitTest {

  String validateEmail(String value) {
    if (value.isEmpty) return Strings.emailEmptyLbl;
    final RegExp emailRegEx = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!emailRegEx.hasMatch(value)) return Strings.emailErrorLbl;
    return null;
  }

  String validatePassword(String value) {
    if (value.length < 4) return Strings.passwordEmptyLbl;
    return null;
  }

}
