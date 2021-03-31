import 'package:firebase_auth/firebase_auth.dart';
import 'package:walk_for_future/services/database.dart';
import 'package:walk_for_future/widgets/user.dart';

class AuthService {

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User currentUser;
  AuthService(this._firebaseAuth);
  UserFromFirebase _userFromFirebaseUser(User user) {
    return user != null ? UserFromFirebase(uid: user.uid) : null;
  }

    Future signInWith(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWith(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      currentUser = user;
      await DatabaseService(uid: user.uid).updateUserData(
          email,
          0);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}