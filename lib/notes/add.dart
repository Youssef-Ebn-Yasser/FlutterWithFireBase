import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/components/customAuthButton.dart';
import 'package:firebase/components/textFormField.dart';
import 'package:firebase/notes/veiw.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  final String catId;
  const AddNote({super.key, required this.catId});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController noteTitleController = TextEditingController();
  final TextEditingController noteContentController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    noteTitleController.dispose();
    noteContentController.dispose();
    super.dispose();
  }

  Future<void> addNote() async {
    if (noteTitleController.text.trim().isEmpty ||
        noteContentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(widget.catId)
          .collection('note') // ✅ Matches NotePage
          .add({
        'name': noteTitleController.text.trim(),
        'content': noteContentController.text.trim(),
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'createdAt': Timestamp.now(),
      });

       Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            NotePage(catId: widget.catId),
                      ),
                    );
    } catch (e) {
      debugPrint("Error adding note: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add note: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Note")),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    CustomTextForm(
                      controller: noteTitleController,
                      hintText: "Enter note title",
                    ),
                    const SizedBox(height: 20),
                    CustomTextForm(
                      controller: noteContentController,
                      hintText: "Enter note content",
                    ),
                    const SizedBox(height: 20),
                    CustomAuthButton(
                      text: "Add Note",
                      bgcolor: Colors.orange,
                      onPress: addNote,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
