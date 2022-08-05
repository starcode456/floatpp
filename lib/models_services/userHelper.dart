import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserHelper {
  Future<bool> updateInfo({String userName, String uni}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update(
        {
          'uni': uni,
          'fullname': userName,
        },
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
