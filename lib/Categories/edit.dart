import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/components/customAuthButton.dart';
import 'package:firebase/components/textFormField.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  final String docId;
  final String oldName;
  const EditCategory({super.key, required this.docId, required this.oldName});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController categoryNameController = TextEditingController();
  bool isLoading = false;

  CollectionReference categories = FirebaseFirestore.instance.collection(
    'Categories',
  );

  Future<void> editCategories() async {
    setState(() => isLoading = true);

    final newName = categoryNameController.text.trim();

    if (newName.isEmpty) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category name cannot be empty")),
      );
      return;
    }

    await categories.doc(widget.docId).update({"CategoryName": newName});

    setState(() => isLoading = false);

    Navigator.of(context).pushNamedAndRemoveUntil("homePage", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Category")),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    CustomTextForm(
                      controller: categoryNameController,
                      hintText: "Update category name",
                    ),
                    const SizedBox(height: 20),
                    CustomAuthButton(
                      text: "Update",
                      bgcolor: Colors.pink,
                      onPress: editCategories,
                    ),
                    const SizedBox(height: 20),
                    Text("Old name is ${widget.oldName} (${widget.docId})"),
                  ],
                ),
        ),
      ),
    );
  }
}
