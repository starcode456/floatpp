import 'package:cloud_firestore/cloud_firestore.dart';

import '../app_utils/appVersion.dart';

class Update {
  var appVersionLocal;
  var appVersionServer;
  bool isUpdateMandatory;

  Update({this.appVersionLocal, this.isUpdateMandatory, this.appVersionServer});

  factory Update.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return Update(
        appVersionServer: data['appVersionServer'] ?? 0,
        isUpdateMandatory: data['isUpdateMandatory'] ?? false,
        appVersionLocal: AppVersionLocal.appVersionLocal);
  }
}
