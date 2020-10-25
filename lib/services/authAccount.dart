import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _authenticate = FirebaseAuth.instance;

  //Create an object of the custom UserProperties based on User
  UserProperties _firebaseUser(User u){
    //if user exists in Firebase, then return uid
    return u == null ? null : UserProperties(uid: u.uid);
  }

  //changes between user login and user logout
  Stream <UserProperties> get user{
    return _authenticate.authStateChanges()
      .map(_firebaseUser);  //map the Firebase user to the custom user model
  }

  //register (email and password)
  Future registerEmailPassword(String email, String password) async{
    try{
      UserCredential result = await _authenticate.createUserWithEmailAndPassword(email: email, password: password);
      User u = result.user;    //get Firebase user
      return _firebaseUser(u); //return custom user object
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //login (email and password)
  Future loginEmailPassword(String email, String password) async{
    try{
      UserCredential result = await _authenticate.signInWithEmailAndPassword(email: email, password: password);
      User u = result.user;    //get Firebase user
      return _firebaseUser(u); //return custom user object
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //login (anonymous)
  Future loginAnon() async{
    try{
      UserCredential result = await _authenticate.signInAnonymously();
      User u = result.user;    //get Firebase user
      return _firebaseUser(u); //return custom user object
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //logout
  Future logout() async{
    try{
      return await _authenticate.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}

//custom user model
class UserProperties{
  final String uid;

  UserProperties({
    this.uid,
  });
}
