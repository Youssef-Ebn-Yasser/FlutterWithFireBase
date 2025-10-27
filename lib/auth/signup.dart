import 'package:firebase/components/customAuthButton.dart';
import 'package:firebase/components/customLogoAuth.dart';
import 'package:firebase/components/textFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool isLoading = false;
  String errorMsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAuthLogo(),
                const SizedBox(height: 20),
                const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sign up to continue using the app",
                  style: TextStyle(fontSize: 22, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                const Text("UserName", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                CustomTextForm(hintText: "Enter your user name", controller: userName),
                const SizedBox(height: 20),
                const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                CustomTextForm(hintText: "Enter your Email", controller: email),
                const SizedBox(height: 20),
                const Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                CustomTextForm(hintText: "Enter your password", controller: password),
                const SizedBox(height: 20),
                if (errorMsg.isNotEmpty)
                  Text(
                    errorMsg,
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 10),
              ],
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomAuthButton(
                    text: "Register",
                    bgcolor: Colors.pinkAccent,
                    onPress: () async {
                      final emailText = email.text.trim();
                      final passwordText = password.text.trim();

                      if (emailText.isEmpty || passwordText.isEmpty) {
                        setState(() {
                          errorMsg = "Email and password cannot be empty!";
                        });
                        return;
                      }

                      setState(() {
                        isLoading = true;
                        errorMsg = '';
                      });

                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: emailText,
                          password: passwordText,
                        );

                        Navigator.of(context).pushReplacementNamed("homePage");
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          if (e.code == 'weak-password') {
                            errorMsg = 'The password provided is too weak.';
                          } else if (e.code == 'email-already-in-use') {
                            errorMsg = 'The account already exists for that email.';
                          } else {
                            errorMsg = e.message ?? 'Unknown Firebase error';
                          }
                        });
                      } catch (e) {
                        setState(() {
                          errorMsg = e.toString();
                        });
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                  ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("login");
              },
              child: const Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: "Have an account? Go to ",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "Login",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ]),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
