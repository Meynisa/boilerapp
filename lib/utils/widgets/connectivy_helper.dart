import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:project_boilerplate/utils/widgets/widget_models.dart';

class ConnectivyHelper extends StatefulWidget {
  final Widget child;
  final Function onConnectionChanged;
  final Function onPressedBtn;

  ConnectivyHelper(
      {this.child,
      this.onConnectionChanged, this.onPressedBtn});

  @override
  _ConnectivyHelperState createState() => _ConnectivyHelperState();
}

class _ConnectivyHelperState extends State<ConnectivyHelper>
    with WidgetsBindingObserver {
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isOnline = true;

  Future<void> initConnectivity() async {
    try {
      await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return;

    await _updateConnectionStatus().then((bool isConnected) => setState(() {
          isOnline = isConnected;
        }));
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      await _updateConnectionStatus().then((bool isConnected) => setState(() {
            isOnline = isConnected;
            if (isOnline) if (widget.onConnectionChanged != null)
              widget.onConnectionChanged();
          }));
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<bool> _updateConnectionStatus() async {
    bool isConnected;
    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
      return false;
    }
    return isConnected;
  }

  @override
  Widget build(BuildContext context) {
    return !isOnline
        ? Container(
      color: Colors.white,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/img_offline.png'),
                SizedBox(
                  height: 10,
                ),
                dynamicText('Tidak Ada Koneksi Internet.',
                    textAlign: TextAlign.center, fontWeight: FontWeight.bold),
                SizedBox(
                  height: 5,
                ),
                dynamicText('Mohon Cek Koneksi Internet Anda', textAlign: TextAlign.center),
                SizedBox(
                  height: 16,
                ),
                defaultButton(context, 'Coba Lagi', onPress: widget.onPressedBtn)
              ],
            ),
        )
        : widget.child;
  }
}
