import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  //Create an object of the custom UserProperties based on User
  UserProperties _firebaseUser(User u){
    //if user exists in Firebase, then return uid
    return u == null ? null : UserProperties(uid: u.uid);
  }

  //login (anonymous)
  Future signInAnon() async{
    try{
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;    //get Firebase user
      return _firebaseUser(user); //return custom user object
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //changes between user login and user logout
  Stream <UserProperties> get user{
    return _auth.authStateChanges()
      .map(_firebaseUser);  //map the Firebase user to the custom user model
  }

  //login (email and password)
  Future signInEmailPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;    //get Firebase user
      return _firebaseUser(user); //return custom user object
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //register (email and password)
  Future registerEmailPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;    //get Firebase user
      return _firebaseUser(user); //return custom user object
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //logout

}

//custom user model
class UserProperties{
  final String uid;

  UserProperties({
    this.uid,
  });
}
