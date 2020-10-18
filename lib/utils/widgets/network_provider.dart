import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:rxdart/subjects.dart';

class NetworkProvider {
  StreamSubscription<ConnectivityResult> _subscription;
  StreamController<ConnectivityResult> _networkStatusController = new BehaviorSubject();

  StreamSubscription<ConnectivityResult> get subscription => _subscription;
  StreamController<ConnectivityResult> get netwokStatusController =>
      _networkStatusController;

  NetworkProvider() {
    _networkStatusController = StreamController<ConnectivityResult>();
    _invokeNetworkStatusListener();
  }

  void _invokeNetworkStatusListener() async {
    _networkStatusController.sink.add(await Connectivity().checkConnectivity());

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      _networkStatusController.sink.add(result);
    });
  }

  void disposeStreams() {
    _subscription.cancel();
    _networkStatusController.close();
  }
}
