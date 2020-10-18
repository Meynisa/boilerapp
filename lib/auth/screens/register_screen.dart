import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_boilerplate/auth/bloc/bloc_register.dart';
import 'package:project_boilerplate/auth/models/input_decoration_model.dart';
import 'package:project_boilerplate/auth/screens/login_screen.dart';
import 'package:project_boilerplate/auth/screens/syarat_webview_screen.dart';
import 'package:project_boilerplate/utils/constants/colors.dart';
import 'package:project_boilerplate/utils/constants/strings.dart';
import 'package:project_boilerplate/utils/constants/theme.dart';
import 'package:project_boilerplate/utils/widgets/api_response.dart';
import 'package:project_boilerplate/utils/widgets/customLoading.dart';
import 'package:project_boilerplate/utils/widgets/widget_models.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => new _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>{
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();

  BlocRegister _blocRegister = BlocRegister();

  @override
  void initState() {
    super.initState();
    _blocRegister.registerStream.listen((data) {
      _handleMessage(data);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _blocRegister.dispose();
  }

  void _handleMessage(message) async {
    print('message : ${message.data}');

    switch (message.status) {
      case Status.LOADING:
        MyDialog(context).loading();
        break;
      case Status.COMPLETED:
        Navigator.of(context).pop();
        alertDialog(context, "Pendaftaran berhasil", "Silakan cek email untuk melakukan verifikasi akun kamu", onPressedOK: (){Navigator.of(context).pop();Navigator.of(context).pop();}, isOneButton: true);
        break;
      case Status.ERROR:
        Navigator.of(context).pop();
        alertDialog(context, "Pendaftaran Gagal", "Mohon cek kembali data yg Anda isi dan pastikan koneksi internet Anda tersedia", onPressedOK: (){Navigator.of(context).pop();}, isOneButton: true);
        break;
    }
  }

  Widget checkbox(bool boolValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.white),
          child: Checkbox(
              checkColor: Colors.white,
              activeColor: SwatchColor.kLightBlueGreen,
              tristate: false,
              value: boolValue,
              onChanged: (bool value) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _blocRegister.isCheckedSink.add(value);
              }),
        ),
        new Flexible(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          'Dengan mendaftarkan diri, saya telah membaca & menyetujui  ',
                      style: dynamicTextStyle()
                    ),
                    TextSpan(
                        text: 'Syarat & Ketentuan',
                        style: dynamicTextStyle(textDecoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigationManager(
                                context,
                                TermsWebScreen('Syarat & Ketentuan'));
                          }),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SwatchColor.kDarkBlue,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: SwatchColor.kDarkBlue,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  color: Colors.white,
                  onPressed: () {
                    navigationManager(context, LoginScreen(),
                        isPushReplaced: true);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 0.0),
                        width: MediaQuery.of(context).size.width / 3,
                        child: Image.asset(
                          'assets/images/img_people.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      dynamicText('Pendaftaran menjadi agen Paruhwaktu',
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                      SizedBox(height: 30),
                      nameField(),
                      SizedBox(height: 10),
                      emailField(),
                      SizedBox(height: 10),
                      phoneField(),
                      SizedBox(height: 10),
                      passwordField(),
                      SizedBox(height: 18),
                      StreamBuilder(
                        stream: _blocRegister.isCheckedStream,
                        builder: (context, AsyncSnapshot<bool> snapshot) {
                          return checkbox(snapshot.data);
                        }
                      ),
                      SizedBox(height: 16),
                      submitButton(),
                      SizedBox(height: 20),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nameField() {
    return StreamBuilder(
      stream: _blocRegister.name,
      builder: (context, snapshot) {
        return TextFormField(
          autocorrect: false,
          onChanged: _blocRegister.changeName,
          cursorColor: SwatchColor.kLightBlueGreen,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          focusNode: _nameFocus,
          onFieldSubmitted: (term) {
            fieldFocusChange(context, _nameFocus, _emailFocus);
          },
          style: textFieldStyle,
          keyboardType: TextInputType.text,
          decoration: inputDecorationModel(Icons.person,
            Strings.nameLbl, snapshot,
            hintText: Strings.nameHintLbl,
          ),
        );
      }
    );
  }

  Widget emailField() {
    return StreamBuilder(
      stream: _blocRegister.email,
      builder: (context, snapshot) {
        return TextFormField(
          autocorrect: false,
          onChanged: _blocRegister.changeEmail,
          cursorColor: SwatchColor.kLightBlueGreen,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.none,
          focusNode: _emailFocus,
          onFieldSubmitted: (term) {
            fieldFocusChange(context, _emailFocus, _phoneFocus);
          },
          style: textFieldStyle,
          keyboardType: TextInputType.emailAddress,
          decoration: inputDecorationModel(Icons.email, Strings.emailLbl, snapshot,
              hintText: Strings.emailHintLbl),
        );
      }
    );
  }

  Widget phoneField() {
    return StreamBuilder(
      stream: _blocRegister.phone,
      builder: (context, snapshot) {
        return TextFormField(
          autocorrect: false,
          onChanged: _blocRegister.changePhone,
          cursorColor: SwatchColor.kLightBlueGreen,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.none,
          focusNode: _phoneFocus,
          onFieldSubmitted: (term) {
            fieldFocusChange(context, _phoneFocus, _passwordFocus);
          },
          style: textFieldStyle,
          keyboardType: TextInputType.phone,
          decoration: inputDecorationModel(Icons.phone, Strings.phoneLbl, snapshot,
              hintText: Strings.phoneHintLbl),
        );
      }
    );
  }

  Widget passwordField() {
    return StreamBuilder(
        stream: _blocRegister.password,
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: _blocRegister.seenStream,
              builder: (context, AsyncSnapshot<bool> seen) {
                return TextFormField(
                  autocorrect: false,
                  onChanged: _blocRegister.changePassword,
                  cursorColor: SwatchColor.kLightBlueGreen,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.none,
                  focusNode: _passwordFocus,
                  obscureText: seen.data,
                  onFieldSubmitted: (value) {
                    _passwordFocus.unfocus();
                  },
                  style: textFieldStyle,
                  keyboardType: TextInputType.text,
                  decoration: inputDecorationModel(Icons.vpn_key, Strings.passwordLbl, snapshot,
                      hintText: Strings.passwordHintLbl, suffixIcon:
                      seen.data ? Icons.visibility : Icons.visibility_off,
                      isSuffix: true,
                      bloc: _blocRegister,
                      seen: seen.data),
                );
              }
          );
        }
    );
  }

  Widget confirmPasswordField() {
    return StreamBuilder(
      stream: _blocRegister.password,
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: _blocRegister.seenStream,
          builder: (context, AsyncSnapshot<bool> seen) {
            return TextFormField(
              autocorrect: false,
              onChanged: _blocRegister.changePassword,
              cursorColor: SwatchColor.kLightBlueGreen,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.none,
              focusNode: _passwordFocus,
              obscureText: seen.data,
              onFieldSubmitted: (value) {
                _passwordFocus.unfocus();
              },
              style: textFieldStyle,
              keyboardType: TextInputType.text,
              decoration: inputDecorationModel(Icons.vpn_key, Strings.passwordLbl, snapshot,
                  hintText: Strings.passwordHintLbl, suffixIcon:
                  seen.data ? Icons.visibility : Icons.visibility_off,
                  isSuffix: true,
                  bloc: _blocRegister,
                  seen: seen.data),
            );
          }
        );
      }
    );
  }

  Widget submitButton() {
    return StreamBuilder(
      stream: _blocRegister.submitValid,
      builder: (context, snapshot) {
        return ClipRRect(
          borderRadius: new BorderRadius.all(Radius.circular(5)),
          child: Container(
            width: double.infinity,
            color: snapshot.hasData
                ? SwatchColor.kLightBlueGreen
                : SwatchColor.kDarkGrey,
            height: 50,
            child: MaterialButton(
              child: dynamicText(Strings.registerLbl, color: Colors.white),
              onPressed: snapshot.hasData ? _blocRegister.submit : null,
            ),
          ),
        );
      }
    );
  }
}
