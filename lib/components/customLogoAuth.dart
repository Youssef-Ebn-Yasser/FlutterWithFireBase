import 'package:flutter/material.dart';

class CustomAuthLogo extends StatelessWidget {
  const CustomAuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: 70,
                    height: 70,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(50),
                    ) ,
                    child: Image.asset("images/logo.png",height: 40,width:40,),),
                );
  }
}