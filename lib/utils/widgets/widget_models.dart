import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:project_boilerplate/utils/widgets/customLoading.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'customLoading.dart';
import 'package:html/parser.dart';

//WIDGET TEXT
dynamicText(String text,
    {Color color,
    double fontSize = 14,
    FontWeight fontWeight,
    FontStyle fontStyle = FontStyle.normal,
    TextOverflow overflow,
    TextAlign textAlign,
    bool price = false,
    bool number = false,
    String fontFamily = "Roboto",
    int maxLines,
    TextDecoration textDecoration}) {
  FlutterMoneyFormatter fmf;
  if (number || price) {
    fmf = new FlutterMoneyFormatter(
      amount: (text != null && text != "") ? double.parse(text) : 0.0,
      settings: MoneyFormatterSettings(
        symbol: !number ? 'Rp' : '',
        thousandSeparator: '.',
        decimalSeparator: ',',
        symbolAndNumberSeparator: ' ',
        fractionDigits: 0,
        compactFormatType: CompactFormatType.short,
      ),
    );
  }
  return Text(
    text != null ? price || number ? fmf.output.symbolOnLeft : text : "",
    style: dynamicTextStyle(
        fontWeight: fontWeight,
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        textDecoration: textDecoration),
    overflow: overflow,
    textAlign: textAlign,
    maxLines: maxLines,
  );
}

TextStyle dynamicTextStyle(
    {FontWeight fontWeight,
    Color color,
    double fontSize = 16,
    String fontFamily = "Roboto",
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration textDecoration}) {
  return TextStyle(
    fontFamily: fontFamily,
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    decoration: textDecoration,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}

String parseDecimal(String value) {
  if (value != "0") {
    value = value.substring(0, value.length - 3);
    value = value.replaceAll(",", "");
  }
  return value;
}

//WIDGET INPUT DECORATION FOR TEXTFIELD
InputDecoration textInputDecorationWidget(
    String lblText, //AsyncSnapshot snapshot,
    {IconData icon,
    String prefixText = '',
    bool isPrefix = false,
    bool isSuffix = false,
    String hintText,
    errorText = ''}) {
  return InputDecoration(
    fillColor: Colors.white,
    filled: true,
    prefixText: prefixText,
    prefixIcon: isPrefix
        ? Icon(
            icon,
            color: SwatchColor.kLightBlueGreen,
          )
        : null,
    labelStyle: TextStyle(
        fontFamily: "Roboto",
        color: SwatchColor.kLightBlueGreen,
        fontWeight: FontWeight.normal,
        fontSize: 14),
    errorStyle: TextStyle(
        fontFamily: "Roboto",
        color: Colors.red,
        fontWeight: FontWeight.normal,
        fontSize: 14),
    errorText: errorText,
    enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Colors.black12, style: BorderStyle.solid)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: SwatchColor.kLightBlueGreen,
        ),
        borderRadius: BorderRadius.all(Radius.circular(4))),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(4))),
    labelText: lblText,
    hintText: hintText,
  );
}

//TEXT FIELD FOCUS CHANGE
fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

//NAVIGATION MANAGER
navigationManager(context, Widget pageScreen, {isPushReplaced = false}) {
  print('${pageScreen.toString()}');
  isPushReplaced
      ? Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => pageScreen,
              settings: RouteSettings(name: '${pageScreen.toString()}')))
      : Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => pageScreen,
              settings: RouteSettings(name: '${pageScreen.toString()}')));
}

// SAVE LOCAL DATA STORAGE
savePreferences(String key,
    {bool boolValue,
    int intValue,
    double doubleValue,
    String stringValue}) async {
  var ref = await SharedPreferences.getInstance();
  if (boolValue != null) {
    print('boolValue: $boolValue');
    ref.setBool(key, boolValue);
  } else if (intValue != null) {
    print('intValue: $intValue');
    ref.setInt(key, intValue);
  } else if (doubleValue != null) {
    print('doubleValue: $doubleValue');
    ref.setDouble(key, doubleValue);
  } else if (stringValue != null) {
    print('stringValue: $stringValue');
    ref.setString(key, stringValue);
  }
}

//GET LOCAL DATA STORAGE
getPreferences(String key, {kType}) async {
  var ref = await SharedPreferences.getInstance();
  var value;

  if (kType == 'int') {
    value = ref.getInt(key);
  } else if (kType == 'double') {
    value = ref.getDouble(key);
  } else if (kType == 'string') {
    print('stringValue: $kType');
    value = ref.getString(key);
  } else if (kType == 'bool') {
    value = ref.getBool(key);
  }
  return value;
}

//BOTTOM BAR WIDGET
bottomBarIcons({IconData icon, String title}) {
  return BottomNavigationBarItem(
    icon: Icon(
      icon,
      size: 24,
      color: Colors.grey,
    ),
    activeIcon: Icon(
      icon,
      size: 24,
      color: SwatchColor.kLightBlueGreen,
    ),
    title: Text(title),
  );
}

//APPBAR WIDGET
myAppBar(context, String text, int counter,
    {bottom,
    bool actions = false,
    bool isWithLeading = false,
    Widget leading}) {
  return AppBar(
    elevation: 0,
    title: dynamicText(text, fontSize: 18),
    centerTitle: true,
    leading: isWithLeading == false ? Container() : leading,
    actions: <Widget>[
      actions == false
          ? Container()
          : Stack(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.notifications,
                      size: 26.0,
                    ),
                    onPressed: () async {
                    }),
                counter != null
                    ? counter > 0
                        ? new Positioned(
                            right: 12,
                            top: 12,
                            child: new Container(
                              padding: EdgeInsets.all(2),
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 10,
                                minHeight: 10,
                              ),
//                        child: Text(
//                          '$counter',
//                          style: TextStyle(
//                            color: Colors.white,
//                            fontSize: 10,
//                          ),
//                          textAlign: TextAlign.center,
//                        ),
                            ),
                          )
                        : new Container(
                            width: 0,
                            height: 0,
                          )
                    : new Container(
                        width: 0,
                        height: 0,
                      )
              ],
            )
    ],
    backgroundColor: SwatchColor.kBlueGreen,
    bottom: bottom,
  );
}

//TIME UTILS
String timestampToDateString(DateFormat dateFormat, int timestamp) {
  return dateFormat.format(new DateTime.fromMillisecondsSinceEpoch(timestamp));
}

//CONVERTER STRING TO DATE
DateTime dateStringToDateTime(String dateString) {
  return DateTime.parse(dateString).toLocal();
}

//DATE FORMATTER
String dateFormat(DateTime date, {String dateFormat = "MMM dd, yyyy"}) {
  return DateFormat(dateFormat).format(date);
}

//CALCULATE DIFFERENTIATE DAYS
String calculateDiffInDays(DateTime dateTime) {
  var dateFormatter = new DateFormat("hh:mm a");
  var dateFormatterPast = new DateFormat("dd/MM/yyyy");

  var diffInDays =
      dateTime.difference(DateTime.now()).inDays; //differentiate by days
  return diffInDays == 0
      ? '${dateFormatter.format(dateTime)}'
      : '${dateFormatterPast.format(dateTime)}';
}

 int calculateDiffInMonth(DateTime dateTime) {
  var diffInDays =
      ((dateTime.difference(DateTime.now()).inDays.abs())/30).floor(); //diffe
  return diffInDays ;
}

//IMAGE UTILS
Widget fadeInImage(String assetImg,
    {String imgPlaceholder = "assets/images/img_placeholder.png",
    double width,
    double height}) {
  return FadeInImage.assetNetwork(
    placeholder: imgPlaceholder,
    image: assetImg ?? "",
    width: width,
    height: height,
    fit: BoxFit.cover,
  );
}

void launchWhatsApp({
  @required String phone,
  @required String message,
}) async {
  String url() {
    if (Platform.isIOS) {
      return "wa.me/$phone/?text=${Uri.parse(message)}";
    } else {
      return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
    }
  }

  if (await canLaunch(url())) {
    await launch(url());
  } else {
    throw 'Could not launch ${url()}';
  }
}

//DEFAULT BUTTON
defaultButton(BuildContext context, String label, {Function onPress}) {
  return MaterialButton(
    disabledColor: SwatchColor.kLightGrey,
    height: 50,
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(8.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(0.0),
      child: dynamicText(label, color: Colors.white, fontSize: 16.0),
    ),
    color: SwatchColor.kLightBlueGreen,
    onPressed: onPress,
  );
}

//CHAT TYPE ICON
String chatTypeIcon(String type) {
  print('chatType: $type');
  if (type == 'telegram') {
    return 'assets/icons/icon_telegram.png';
  } else if (type == 'facebook') {
    return 'assets/icons/icon_facebook.png';
  } else if (type == 'twitter-Mention') {
    return 'assets/icons/icon_twitter.png';
  } else if (type == 'whatsapp') {
    return 'assets/icons/icon_whatsapp.png';
  } else if (type == 'gmail') {
    return 'assets/icons/icon_gmail.png';
  } else if (type == 'line') {
    return 'assets/icons/icon_line.png';
  } else {
    return 'assets/icons/icon_telegram.png';
  }
}

// SHIMMER COLUMN PLACEHOLDER
Widget columnPlaceholder() {
  return Column(
    children: <Widget>[
      Shimmer.fromColors(
          child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
              ),
              title: Container(
                width: 100,
                height: 12,
                color: Colors.grey[300],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 4.0,
                  ),
                  Container(
                    width: 200,
                    height: 10,
                    color: Colors.grey[300],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Container(
                    width: 200,
                    height: 10,
                    color: Colors.grey[300],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Container(
                    width: 100,
                    height: 10,
                    color: Colors.grey[300],
                  ),
                ],
              )),
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100]),
    ],
  );
}

Widget emptyPlaceholderWidget(String message, String subMessage) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          "assets/images/img_emptyplaceholder.png",
          height: 180,
        ),
        SizedBox(height: 30.0),
        dynamicText(
          message,
          fontSize: 17.0,
          color: Colors.black87,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          child: Text(
            subMessage,
            style: TextStyle(fontSize: 15.0, color: Colors.black45),
            textAlign: TextAlign.center,
          ),
        ),
      ]);
}

Future<void> alertDialog(BuildContext context, String text, String desc,
    {IconData icon = Icons.warning,
    Color colorIcon = SwatchColor.kLightBlueGreen,
    bool isNavigate = false,
    navigate,
    MyDialog view,
    isOneButton = false,
    String imgAsset = "",
    String roomId,
    Function onPressedOK,
    bool noButton = false,
    bool isDismissable = true}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: isDismissable, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: imgAsset != ""
                    ? Image.asset(
                        imgAsset,
                        height: 70,
                      )
                    : Icon(
                        icon,
                        color: colorIcon,
                        size: 70,
                      ),
              ),
              SizedBox(height: 10),
              dynamicText(text,
                  fontSize: 20,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold),
              SizedBox(height: 20),
              dynamicText(desc, fontSize: 16, textAlign: TextAlign.center),
              SizedBox(height: 30),
              noButton == false
                  ? isOneButton
                      ? defaultButton(context, 'OK', onPress: onPressedOK)
                      : Container(
                          height: 36,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FlatButton(
                                  color: Colors.white,
                                  shape: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: SwatchColor.kLightBlueGreen),
                                    borderRadius: new BorderRadius.circular(8),
                                  ),
                                  child: dynamicText('TIDAK',
                                      color: SwatchColor.kLightBlueGreen,
                                      fontSize: 16),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              defaultButton(context, 'YA', onPress: onPressedOK)
                            ],
                          ))
                  : Container(),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> connectionAlert(BuildContext context, Function btnPress) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: Color.fromRGBO(255, 205, 5, 1)),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 60.0, bottom: 60.0),
                  child: Image.asset('assets/images/img_wa_disconnect.png'),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: Center(
                  child: dynamicText("WhatsApp tidak terhubung internet",
                      fontSize: 26.0, textAlign: TextAlign.center),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: Center(
                  child: dynamicText(
                      "Hubungkan kembali WhatsApp ke internet dan Anda bisa kembali bekerja",
                      fontSize: 16.0,
                      textAlign: TextAlign.center,
                      color: Colors.black45),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                  color: Colors.white,
                  shape: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: new BorderRadius.circular(8),
                  ),
                  child: dynamicText('Laporkan',
                      color: Colors.black87, fontSize: 16),
                  onPressed: btnPress),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );
    },
  );
}

String parseHtmlString(String htmlString) {
  var document = parse(htmlString);
  String parsedString = parse(document.body.text).documentElement.text;
  return parsedString;
}

hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height * 0.85);
    p.arcToPoint(
      Offset(0.0, size.height * 0.85),
      radius: const Radius.elliptical(40.0, 10.0),
      rotation: 0.0,
    );
    p.lineTo(0.0, 0.0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

Widget customLoading() {
  return Center(
    child: CircularProgressIndicator(),
  );
}