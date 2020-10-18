import 'package:flutter/material.dart';
import 'package:project_boilerplate/auth/bloc/bloc_login.dart';
import 'package:project_boilerplate/auth/bloc/provider_login.dart';
import 'package:project_boilerplate/auth/models/input_decoration_model.dart';
import 'package:project_boilerplate/auth/screens/forgot_pass_screen.dart';
import 'package:project_boilerplate/auth/screens/home_screen.dart';
import 'package:project_boilerplate/auth/screens/register_screen.dart';
import 'package:project_boilerplate/utils/constants/colors.dart';
import 'package:project_boilerplate/utils/constants/strings.dart';
import 'package:project_boilerplate/utils/constants/theme.dart';
import 'package:project_boilerplate/utils/widgets/api_response.dart';
import 'package:project_boilerplate/utils/widgets/customLoading.dart';
import 'package:project_boilerplate/utils/widgets/widget_models.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  BlocLogin _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocLogin();
    _bloc.loginListStream.listen((data) {
      _handleMessage(data);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  void _handleMessage(message) async {
    print('message : ${message.status}');

    switch (message.status) {
      case Status.LOADING:
        MyDialog(context).loading();
        break;
      case Status.COMPLETED:
        Navigator.of(context).pop();
        await Future.delayed(const Duration(milliseconds: 30));
        navigationManager(context, HomeScreen());
        break;
      case Status.ERROR:
        Navigator.of(context).pop();
        await _showMessage(message.message);
        break;
    }
  }

  Future<void> _showMessage(String message) => _scaffoldKey.currentState
      ?.showSnackBar(
        SnackBar(
          content: dynamicText(message),
          duration: const Duration(seconds: 5),
        ),
      )
      ?.closed;

  @override
  Widget build(BuildContext context) {
    return ProviderLogin(
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: _scaffoldKey,
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
                          emailField(_bloc),
                          SizedBox(height: 10),
                          passwordField(_bloc),
                          SizedBox(height: 15),
                          submitButton(_bloc),
                          SizedBox(height: 30),
                          FlatButton(
                              onPressed: () {
                                navigationManager(context, ForgotPassScreen());
                              },
                              child: dynamicText(Strings.forgotPassLbl,
                                  color: Colors.white)),
                          SizedBox(height: 15),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Divider(
                                color: Colors.white,
                              )),
                              SizedBox(width: 10),
                              dynamicText(Strings.orLbl, color: Colors.white),
                              SizedBox(width: 10),
                              Expanded(
                                  child: Divider(
                                color: Colors.white,
                              )),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              dynamicText(Strings.accountLbl,
                                  color: Colors.white),
                              FlatButton(
                                padding: EdgeInsets.all(5.0),
                                onPressed: () {
                                  navigationManager(context, RegisterScreen());
                                },
                                child: dynamicText(Strings.btnAccLbl,
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
      ),
    );
  }

  Widget emailField(BlocLogin bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextFormField(
          autocorrect: false,
          onChanged: bloc.changeEmail,
          cursorColor: SwatchColor.kLightBlueGreen,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.none,
          focusNode: _emailFocus,
          onFieldSubmitted: (term) {
            fieldFocusChange(context, _emailFocus, _passwordFocus);
          },
          style: textFieldStyle,
          keyboardType: TextInputType.emailAddress,
          decoration: inputDecorationModel(Icons.person, Strings.emailLbl, snapshot,
              hintText: Strings.emailHintLbl),
        );
      },
    );
  }

  Widget passwordField(BlocLogin bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return StreamBuilder(
            stream: bloc.seenStream,
            builder: (context, AsyncSnapshot<bool> seen) {
              return TextFormField(
                autocorrect: false,
                onChanged: bloc.changePassword,
                cursorColor: SwatchColor.kLightBlueGreen,
                focusNode: _passwordFocus,
                obscureText: seen.data,
                onFieldSubmitted: (value) {
                  _passwordFocus.unfocus();
                },
                style: textFieldStyle,
                decoration: inputDecorationModel(
                    Icons.vpn_key, Strings.passwordLbl, snapshot,
                    hintText: Strings.passwordHintLbl,
                    suffixIcon:
                        seen.data ? Icons.visibility : Icons.visibility_off,
                    isSuffix: true,
                    bloc: bloc,
                    seen: seen.data),
              );
            });
      },
    );
  }

  Widget submitButton(BlocLogin bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
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
              child: dynamicText(Strings.loginLbl, color: Colors.white),
              onPressed: snapshot.hasData ? bloc.submit : null,
            ),
          ),
        );
      },
    );
  }
}
