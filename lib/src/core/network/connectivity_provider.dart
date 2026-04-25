import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

enum ConnectivityStatus {
  wifi,
  mobile,
  ethernet,
  vpn,
  bluetooth,
  other,
  none,
}

@riverpod
Stream<ConnectivityStatus> connectivityStatus(ConnectivityStatusRef ref) {
  return Connectivity().onConnectivityChanged.map((results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return ConnectivityStatus.none;
    }
    if (results.contains(ConnectivityResult.wifi)) {
      return ConnectivityStatus.wifi;
    }
    if (results.contains(ConnectivityResult.mobile)) {
      return ConnectivityStatus.mobile;
    }
    if (results.contains(ConnectivityResult.ethernet)) {
      return ConnectivityStatus.ethernet;
    }
    if (results.contains(ConnectivityResult.vpn)) {
      return ConnectivityStatus.vpn;
    }
    if (results.contains(ConnectivityResult.bluetooth)) {
      return ConnectivityStatus.bluetooth;
    }
    if (results.contains(ConnectivityResult.other)) {
      return ConnectivityStatus.other;
    }
    return ConnectivityStatus.none;
  });
}
