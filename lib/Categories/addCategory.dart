import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/components/customAuthButton.dart';
import 'package:firebase/components/textFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Addcategory extends StatefulWidget {
  @override
  State<Addcategory> createState() => _AddcategoryState();
}

class _AddcategoryState extends State<Addcategory> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController categoryNameController = TextEditingController();

  bool isLoading = false;

  CollectionReference categories = FirebaseFirestore.instance.collection(
    'Categories',
  );

  @override
  void dispose() {
    categoryNameController.dispose();
    super.dispose();
  }

  addCategories() async {
    isLoading = true;
    setState(() {});

    if (categoryNameController.text != null &&
        categoryNameController.text != "") {
      await categories.add({
        'CategoryName': categoryNameController.text,
        "userId": FirebaseAuth.instance.currentUser!.uid,
      });
    } else {
      isLoading = false;
      setState(() {});
      return Future.error("Category name is empty");
    }

    Navigator.of(
      formKey.currentContext!,
    ).pushNamedAndRemoveUntil("homePage", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Category")),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: isLoading
                ? [Center(child: CircularProgressIndicator())]
                : [
                    CustomTextForm(
                      controller: categoryNameController,
                      hintText: "enter category name",
                      key: formKey,
                    ),
                    SizedBox(height: 20),
                    CustomAuthButton(
                      text: "Add",
                      bgcolor: Colors.orange,
                      onPress: () async {
                        await addCategories();
                      },
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
