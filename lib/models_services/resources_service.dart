import 'package:float/models/resourceModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:float/models/submittedResource.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class ResourceHelper {
  Future<List<ResourceModel>> getAllResources() async {
    List<ResourceModel> allResources = [];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('resources').get();
    snapshot.docs.forEach((element) {
      allResources.add(ResourceModel.fromMap(element.data()));
      print(element.data());
    });
    return allResources;
  }

  Future<bool> submitResource(SubmittedResource submittedResource) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.submittedResources)
          .doc(submittedResource.id)
          .set(submittedResource.toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addResourceToFloat(String floatId, String resourceId,
      {@required userProfile}) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.floats)
          .doc(floatId)
          .update({
        'resourceId': FieldValue.arrayUnion([resourceId])
      });
      await FirebaseFirestore.instance
          .collection(Keys.resources)
          .doc(resourceId)
          .update({
        'userImages': FieldValue.arrayUnion([userProfile])
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
