import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatusService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  NetworkStatusService() {
    _connectivity.onConnectivityChanged.listen((status) {
      _controller.add(_isConnected(status as ConnectivityResult));
    });
  }

  Stream<bool> get onStatusChange => _controller.stream;

  Future<bool> checkConnection() async {
    final status = await _connectivity.checkConnectivity();
    return _isConnected(status as ConnectivityResult);
  }

  bool _isConnected(ConnectivityResult result) {
    return result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi;
  }

  void dispose() {
    _controller.close();
  }
}
