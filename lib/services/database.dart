import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_app/services/screenArguments.dart';

class Database {
  //collection reference, if not exist in Firestore, it will be created automatically
  //read, update, remove documents in the collection
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('usersData');

  final String uid;

  Database({this.uid});

  Future<void> updatePersonalData(String email, String fName, String lName) async {
    return await usersCollection.doc(uid).set({
      'uid': uid,
      'email': email,
      'firstName': fName,
      'lastName': lName,
    });
  }

  Future<void> updateWorkout(String wType, String duration) async {
    return await usersCollection.doc(uid).set({
          'workoutType': wType,
          'duration': duration,
        })
        .then((value) => print("Updated workout details!"))
        .catchError(
            (error) => print("Failed to update workout details: $error"));
  }

  //get collection stream data of user's personal info
  Stream<QuerySnapshot> get usersData {
    return usersCollection.snapshots();
  }

  //list of snapshots
  // List<ScreenArguments> collectionList(QuerySnapshot s) {
  //   return s.documents.map((doc) {
  //     return ScreenArguments();
  //   }).toList();
  // }
}
