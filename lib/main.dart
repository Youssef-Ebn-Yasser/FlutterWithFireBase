import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Basic/homePage.dart';
import 'package:firebase/auth/signup.dart';
import 'package:firebase/testHttp.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth/login.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home:FirebaseAuth.instance.currentUser == null ? Login() : HomePage() ,
    routes: {
      "signup":(context)=> SignUp(),
      "login":(context)=> Login(),
      "homePage":(context)=> HomePage(),
    },
  ) ;
  }
}
// firebase_core
// cloud_firestore
// firebase_storage
// firebase_messaging
// firebase_auth
// google_sign_in