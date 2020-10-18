import 'package:project_boilerplate/utils/constants/strings.dart';
import 'package:project_boilerplate/utils/widgets/validator_unit_test.dart';
import 'package:test/test.dart';

void main(){

  ValidatorUnitTest validator = ValidatorUnitTest();

  test('Empty Email Test', (){
    var result = validator.validateEmail('');
    expect(result, Strings.emailEmptyLbl);
  });

  test('Invalid Email Test', (){
    var result = validator.validateEmail('vdnsk');
    expect(result, Strings.emailErrorLbl);
  });

  test('Valid Email Test', (){
    var result = validator.validateEmail('mey@gmail.com');
    expect(result, null);
  });

  test('Empty Password Test', (){
    var result = validator.validatePassword('');
    expect(result, Strings.passwordEmptyLbl);
  });

  test('Invalid Password Test', (){
    var result = validator.validatePassword('ds');
    expect(result, Strings.passwordEmptyLbl);
  });

  test('Valid Password Test', (){
    var result = validator.validatePassword('jksdfnksdf');
    expect(result, null);
  });
}