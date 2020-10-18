import 'package:flutter/material.dart';
import 'package:project_boilerplate/auth/bloc/bloc_login.dart';
import 'package:project_boilerplate/auth/models/input_decoration_model.dart';
import 'package:project_boilerplate/utils/constants/colors.dart';
import 'package:project_boilerplate/utils/constants/theme.dart';
import 'package:project_boilerplate/utils/widgets/api_response.dart';
import 'package:project_boilerplate/utils/widgets/customLoading.dart';
import 'package:project_boilerplate/utils/widgets/widget_models.dart';

class ForgotPassScreen extends StatefulWidget {
  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  BlocLogin _blocLogin = BlocLogin();
  final FocusNode _emailFocus = FocusNode();

  String emailValue = '';

  @override
  void initState() {
    super.initState();
    _blocLogin.forgotPassStream.listen((data) {
      _handleMessage(data);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _blocLogin.dispose();
  }

  void _handleMessage(message) async {
    print('message : ${message.status}');

    switch (message.status) {
      case Status.LOADING:
        MyDialog(context).loading();
        break;
      case Status.COMPLETED:
        Navigator.of(context).pop();
        alertDialog(context, 'Berhasil',
            'Silakan cek email kamu untuk merubah password', onPressedOK: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }, isOneButton: true);
        break;
      case Status.ERROR:
        Navigator.of(context).pop();
        alertDialog(context, "Gagal",
            "Mohon cek kembali data yg Anda isi dan pastikan koneksi internet Anda tersedia",
            onPressedOK: () {
          Navigator.of(context).pop();
        }, isOneButton: true);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: SwatchColor.kDarkBlue,
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/icons/icon_logo.png',
                          width: MediaQuery.of(context).size.width / 1.5,
                        ),
                        SizedBox(height: 20),
                        dynamicText('Lupa Password?',
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        SizedBox(height: 20),
                        emailField(_blocLogin),
                        SizedBox(height: 15),
                        submitButton(_blocLogin),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            dynamicText("Sudah punya akun ?",
                                color: Colors.white),
                            FlatButton(
                              padding: EdgeInsets.all(5.0),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: dynamicText("Masuk Sekarang",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget emailField(BlocLogin bloc) {
    return StreamBuilder(
        stream: _blocLogin.email,
        builder: (context, snapshot) {
          return TextFormField(
            autocorrect: false,
            focusNode: _emailFocus,
            onChanged: _blocLogin.changeEmail,
            cursorColor: SwatchColor.kLightBlueGreen,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.none,
            onFieldSubmitted: (term) {
              print('TERM: $term, $snapshot');
              _emailFocus.unfocus();
            },
            style: textFieldStyle,
            keyboardType: TextInputType.emailAddress,
            decoration: inputDecorationModel(Icons.person, "Email", snapshot,
                hintText: "Email"),
          );
        });
  }

  Widget submitButton(BlocLogin bloc) {
    return StreamBuilder(
      stream: _blocLogin.email,
      builder: (context, snapshot) {
        print('SNAP: $snapshot');
        return ClipRRect(
          borderRadius: new BorderRadius.all(Radius.circular(5)),
          child: Container(
            width: double.infinity,
            color: snapshot.hasData
                ? SwatchColor.kLightBlueGreen
                : SwatchColor.kDarkGrey,
            height: 50,
            child: MaterialButton(
                child: dynamicText("Kirim", color: Colors.white),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  snapshot.hasData
                      ? _blocLogin.postForgotPassword(snapshot.data)
                      : null;
                }),
          ),
        );
      },
    );
  }
}
