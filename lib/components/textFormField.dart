import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {

  final String hintText;
  final TextEditingController controller;

  const CustomTextForm({super.key, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(color: const Color.fromARGB(255, 68, 68, 68),
                    fontSize: 16,
                    ),
                    filled: true  ,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color:Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color:Colors.grey.shade200),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 10)
                    
                  ),
                );
  }
}