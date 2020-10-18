import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_boilerplate/utils/constants/strings.dart';
import 'dart:async';
import 'package:project_boilerplate/utils/widgets/widget_models.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsWebScreen extends StatefulWidget {
  final String title;
  TermsWebScreen(this.title);
  @override
  _TermsWebScreenState createState() => _TermsWebScreenState();
}

class _TermsWebScreenState extends State<TermsWebScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, widget.title, 0),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: _onNavigationDelegateExample(),
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        );
      }),
    );
  }

  String _onNavigationDelegateExample() {
    final String contentBase64 = base64Encode(const Utf8Encoder().convert(Strings.kJavascriptTerms));
    return 'data:text/html;base64,$contentBase64';
  }
}