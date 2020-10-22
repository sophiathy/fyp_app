import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  //login (anonymous)
  Future signInAnon() async{
    try{
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //login (email and password)

  //sign up (email and password)

  //logout

}
