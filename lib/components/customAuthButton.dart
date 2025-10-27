import 'package:flutter/material.dart';

class CustomAuthButton extends StatelessWidget {

  final void Function()? onPress;
  final String text ;
  final Color bgcolor;

  const CustomAuthButton({super.key, required this.text, required this.bgcolor, this.onPress});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(onPressed: onPress,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),),
                color: bgcolor,
                height: 50,child: Text(text,style: TextStyle(color: Colors.white,fontSize: 18)
                ));
  }
}