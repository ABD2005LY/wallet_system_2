import 'package:flutter/cupertino.dart';
import 'package:wallet_system_2/services/api.dart';

class BaseProvider with ChangeNotifier {
  bool busy = false;
  Api api = Api();

  void setBusy(bool status) {
    busy = status;
     // Source - https://stackoverflow.com/a
// Posted by Hammad Tariq, modified by community. See post 'Timeline' for change history
// Retrieved 2026-01-07, License - CC BY-SA 4.0
WidgetsBinding.instance.addPostFrameCallback((_){

notifyListeners();
});

  }

  bool failed = false;

  void setFailed(bool status) {
    failed = status;
    notifyListeners();
  }

  String? errorMessage;
  void setErrorMessage(String? msg) {
    errorMessage = msg;
    notifyListeners();
  }
}
