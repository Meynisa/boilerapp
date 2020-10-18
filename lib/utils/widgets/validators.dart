import 'dart:async';

import 'package:project_boilerplate/utils/constants/strings.dart';
import 'package:project_boilerplate/utils/widgets/api_response.dart';

class Validators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.isEmpty) {
    } else {
      final RegExp emailRegEx = new RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      if (!emailRegEx.hasMatch(email)) {
        sink.addError(Strings.emailErrorLbl);
      } else {
        sink.add(email);
      }
    }
  });

  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length < 3 && name.length != 0) {
      sink.addError(Strings.nameEmptyLbl);
    } else {
      sink.add(name);
    }
  });

  final validateCheckbox =
      StreamTransformer<bool, bool>.fromHandlers(handleData: (checkbox, sink) {
    if (checkbox == false) {
      sink.addError('Mohon centang Syarat dan Ketentuan');
    } else {
      sink.add(checkbox);
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length < 4 && password.length != 0) {
      sink.addError(Strings.passwordErrorLbl);
    } else if (password.length == 0)
      sink.addError(null);
    else {
      sink.add(password);
    }
  });

  final validateConfirmPassword =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (password, sink) {
    if (password.length < 4 && password.length != 0) {
      sink.addError(Strings.passwordErrorLbl);
    } else if (password.length == 0)
      sink.addError(null);
    else {
      sink.add(password);
    }
  });

  final validatePricing =
      StreamTransformer<String, String>.fromHandlers(handleData: (price, sink) {
    if (price.length != 0) {
      price = price.replaceAll(new RegExp(r'[^\w\s]+'), '');
      print("price: $price");
      if (price.length < 4) {
        if (int.parse(price) == 0) {
          sink.addError(Strings.priceEmptyLbl);
        } else {
          sink.addError(Strings.priceLessLbl);
        }
      } else {
        sink.add(price);
      }
    }
  });

  final validatePhone =
      StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
    Pattern pattern = r'(^\+?62|0[0-9]{9,12}$)';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(phone) && phone.length != 0) {
      print('REGEX: $regex');
      sink.addError(Strings.phoneErrorLbl);
    } else
      sink.add(phone);
  });

  final validateInputTxt = StreamTransformer<String, String>.fromHandlers(
      handleData: (content, sink) {
    if (content.length == 0) {
      sink.addError('Tulis Pesanmu');
    } else {
      sink.add(content);
    }
  });
}
