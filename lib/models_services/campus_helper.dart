import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/models/campus_model.dart';
import 'package:float/models/campus_request.dart';
import 'package:float/models/user_shelf.dart';

import '../constants.dart';

class CampusHelper {
  ///
  ///
  ///
  Future<CampusModel> getCurentUserCampus() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(Keys.campuses)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();
      if (snapshot.data() != null) {
        print('DATA FROM THE CAMPUS ${snapshot.data()}');
        return CampusModel.fromMap(snapshot.data());
      }
      return null;
    } catch (e) {
      print('THis is the rror in getting vurrenty user campus model $e');
      return null;
    }
  }

  ///
  ///
  ///
  sendCampusRequest(CampusRequestModel campusRequestModel) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.campusRequests)
          .doc(campusRequestModel.requestId)
          .set(campusRequestModel.toMap());
    } catch (e) {
      print('THis is the erorro in sending campus request $e');
    }
  }

  ///
  ///
  ///
  acceptCampusRequest(
      CampusRequestModel campusRequestModel, CampusUser campusUser) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.campuses)
          .doc(campusRequestModel.requesterId)
          .set(
        {
          'campusUsers': FieldValue.arrayUnion(
            [
              campusUser.toMap(),
            ],
          ),
        },
        SetOptions(merge: true),
      );
      await FirebaseFirestore.instance
          .collection(Keys.campusRequests)
          .doc(campusRequestModel.requestId)
          .delete();
    } catch (e) {
      print('THis is the error in accepting the campus request $e');
    }
  }

  ///
  ///
  ///
  removeFromCampus(CampusUser campusUser) async {
    print("REMOVEDDD ISERRRR    ${campusUser.toMap()}");
    try {
      await FirebaseFirestore.instance
          .collection(Keys.campuses)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set(
        {
          'campusUsers': FieldValue.arrayRemove(
            [
              campusUser.toMap(),
            ],
          ),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print('THis is the error in accepting the campus request $e');
    }
  }

  ///
  ///
  ///
  Future<List<CampusRequestModel>> getCurrentUserRequests() async {
    List<CampusRequestModel> currentUserRequests = [];
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(Keys.campusRequests)
          .where('recieverId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .get();
      if (snapshot.docs.length > 0) {
        snapshot.docs.forEach((element) {
          currentUserRequests.add(CampusRequestModel.fromMap(element.data()));
        });
      }
      return currentUserRequests;
    } catch (e) {
      print('THis is the error in getting current user requests $e');
      return currentUserRequests;
    }
  }

  ///
  ///
  ///
  Future<List<UserShelfModel>> getAllUserShelfs() async {
    List<UserShelfModel> allUsersShelfs = [];
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(Keys.userShelfs).get();
      if (snapshot.docs.length > 0) {
        snapshot.docs.forEach((element) {
          allUsersShelfs.add(UserShelfModel.fromMap(element.data()));
        });
      }
      return allUsersShelfs;
    } catch (e) {
      print('THis is the error in all user shelfs $e');
      return allUsersShelfs;
    }
  }

  ///
  ///
  ///
  addToShelf(UserShelfModel userShelfModel) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.userShelfs)
          .doc(userShelfModel.id)
          .set(userShelfModel.toMap());
    } catch (e) {
      print('THis is the erorro in sending campus request $e');
    }
  }

  ///
  ///
  ///
  deleteExpired() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(Keys.userShelfs)
          .where('dateAdded',
              isGreaterThan: Timestamp.fromDate(
                DateTime.now().add(
                  Duration(days: 7),
                ),
              ))
          .get();
      for (int i = 0; i < snapshot.docs.length; i++) {
        await snapshot.docs[i].reference.delete();
      }
    } catch (e) {
      print('THIS IS THE ERROR IN DELTING EXPIRED $e');
    }
  }
}
