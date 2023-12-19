import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:microhabits/authentication/helper/helper.dart';
import 'package:microhabits/authentication/services/databseservice.dart';


class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  

  Future loginUser(String email, String password, ) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user!= null) {
        

        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future registerUser(String fullname, String email, String password, ) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user!= null) {
        await DatabaseService(uid: user.uid).updateUserData(email, fullname);

        return true;
      }  
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  Future signOut() async {
    try {
      await Helperfunctions.saveUserLoggedInStatus(false);
      await Helperfunctions.saveUserEmailSF("");
      await Helperfunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}

