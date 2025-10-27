import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class TestHttp extends StatefulWidget {
  const TestHttp({super.key});

  @override
  State<TestHttp> createState() => _TestHttpState();
}

class _TestHttpState extends State<TestHttp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test HTTP'),
      ),
      body: ListView(
        children: [
          Center(
            child: MaterialButton(onPressed: () async{
                var response =await get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
                var body = jsonDecode(response.body);
                print(body[0]["title"]);
            }, child: Text('Test HTTP Request'),color: Colors.blue,),
          ),
        ],
      )  
    );
  }
}