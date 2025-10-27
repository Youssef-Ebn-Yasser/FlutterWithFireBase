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
  void initState() {

FirebaseFirestore.instance.collection('test').add({
  'name': 'Flutter Firebase',
  'timestamp': FieldValue.serverTimestamp(),
}).then((value) {
  print('Data saved successfully');
}).catchError((error) {
  print('Failed to save data: $error');
});

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    analytics.logEvent(
      name: 'test_event',
      parameters: {'success': true},
    );

    FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home:Login() ,
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