import 'package:cloud_firestore/cloud_firestore.dart';

class UserFromFirebase {
  final String uid;

  UserFromFirebase({this.uid});
}

class UserData {
  final String uid;
  final String email;
  final int points;

  UserData(
      {this.uid,
      this.email,
      this.points});

  factory UserData.fromDocument(DocumentSnapshot doc) {
    return UserData(
        uid: doc['uid'],
        email: doc['email'],
        points: doc['points']);
  }
}
