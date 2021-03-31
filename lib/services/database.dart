import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:walk_for_future/widgets/user.dart';

class DatabaseService {
  static DatabaseService instance = DatabaseService();

  final String uid;
  DatabaseService({this.uid});

  UserFromFirebase currentUser;

  //collection reference
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String email, int points) async {
    return await usersRef.doc(uid).set({
      'uid': uid,
      'email': email,
      'points': points
    });
  }
}
