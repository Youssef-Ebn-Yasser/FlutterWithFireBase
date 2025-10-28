import 'package:firebase/components/customAuthButton.dart';
import 'package:firebase/components/customLogoAuth.dart';
import 'package:firebase/components/textFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start  ,
              children: [
                CustomAuthLogo(),
                Text("Login",
                style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                SizedBox(height: 10),
                Text("Login to continue using the app",
                style: TextStyle(fontSize: 22,fontWeight: FontWeight.normal,color: Colors.grey),),
                SizedBox(height: 20,),
                Text("Email",style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10),

                CustomTextForm(hintText:"Enter your Email",controller: email,),

                SizedBox(height: 20,),
                Text("Password",style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10),
                                CustomTextForm(hintText:"Enter your password",controller: password,),  
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.topRight,
                  child: Text("forget password ??",style: TextStyle(fontSize: 14,),)),

                SizedBox(height: 20,),
                
              ],
            ),
            CustomAuthButton(text: "Login",onPress: ()async{
                                  try {
                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email.text,
                        password: password.text
                      );

                      Navigator.of(context).pushNamedAndRemoveUntil("homePage", (route)=>false);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }
            },bgcolor: Colors.pinkAccent,),

            SizedBox(height: 20,),
            CustomAuthButton(text: "Login with google",onPress: (){},bgcolor: Colors.green,),

            SizedBox(height: 20,),

            InkWell(
              onTap: () => Navigator.of(context).pushNamed("signup"),
              child: Text.rich(  TextSpan(children: [
                TextSpan(text: "Do not have an account ? ",style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold)),
                TextSpan(text: "register",style: TextStyle(color: Colors.blue,
                fontWeight: FontWeight.bold)),
              ]),textAlign: TextAlign.center,),
            )
          ],
        ),
      ),
    );
  }
}