import 'package:connectivity/connectivity.dart';

class NetworkStatus {
  static const String NETWORK_IP = "192.168.88.21";
  static const String PORT = "2502";
  static const int ONLINE = 0;
  static const int OFFLINE = 1;
  static const int LOADING = 2;
  static const int ADDING = 3;
  static const int DELETING = 4;
  bool isConnected = false;

  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.wifi) {
      if(!isConnected){
        isConnected = true;
//        synchronize();
      }
      return true;
    }

    isConnected = false;
    return false;
  }
}