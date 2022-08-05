import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:float/models/universityModel.dart';

import '../constants.dart';

class UniversityHelper {
   Future<List<UniversityModel>> getAllUniversities() async {
    List<UniversityModel> universtiesList = [];
    try {
      await FirebaseFirestore.instance
          .collection(Keys.universities)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          universtiesList.add(UniversityModel.fromMap(element.data()));
        });
      });
      return universtiesList;
    } catch (e) {
      print('Error in getting all the univeristies $e');
      return [];
    }
  }
}