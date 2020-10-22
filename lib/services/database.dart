import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  //collection reference, if not exist in Firestore, it will be created automatically
  //read, update, remove documents in the collection
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('usersData');
}