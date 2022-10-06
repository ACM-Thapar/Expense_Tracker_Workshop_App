import 'package:connectivity_plus/connectivity_plus.dart';

final Connectivity _connectivity = Connectivity();

bool checkInternet() {
  bool check = false;
  _connectivity.onConnectivityChanged.listen(
    (event) {
      if (event == ConnectivityResult.none) {
        check = true;
      } else {
        check = false;
      }
    },
  );
  return check;
}
