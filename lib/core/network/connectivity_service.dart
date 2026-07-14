import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();

    // ignore: unrelated_type_equality_checks
    return result != ConnectivityResult.none;
  }

  Stream<bool> get connectionStream {
    return _connectivity.onConnectivityChanged.map((result) {
      // ignore: unrelated_type_equality_checks
      return result != ConnectivityResult.none;
    });
  }
}
