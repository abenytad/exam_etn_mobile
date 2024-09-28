import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> hasInternetConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile || 
           connectivityResult == ConnectivityResult.wifi;
  }
}