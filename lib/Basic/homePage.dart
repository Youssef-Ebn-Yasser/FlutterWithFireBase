import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signOut() async {
    await _auth.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil("login",(route)=>false);
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    "Welcome, ${user.email}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Text("User ID: ${user.uid}"),


                  FirebaseAuth.instance.currentUser!.emailVerified  ?
                 Text("your email is already verifies") 
               :MaterialButton(onPressed: (){
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
               },child: 
                Text("you are not verified verifie now"),color: Colors.blue,
                textColor: Colors.white,),
                ],
              )
            : const Text("No user signed in"),
      ),);
    
  }
}
