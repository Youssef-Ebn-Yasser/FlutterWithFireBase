import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/components/customAuthButton.dart';
import 'package:firebase/components/textFormField.dart';
import 'package:firebase/notes/veiw.dart';
import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  final String catId;     // The parent category ID
  final String noteId;    // The note document ID
  final String oldTitle;  // The old note title
  final String? oldContent; // The old note content (nullable)

  const EditNote({
    super.key,
    required this.catId,
    required this.noteId,
    required this.oldTitle,
    this.oldContent,
  });

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  bool isLoading = false;

  late final CollectionReference notesCollection;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.oldTitle;
    contentController.text = widget.oldContent ?? "";
    notesCollection = FirebaseFirestore.instance
        .collection('Categories')
        .doc(widget.catId)
        .collection('note');
  }

  Future<void> editNote() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await notesCollection.doc(widget.noteId).update({
        "name": titleController.text.trim(),
        "content": contentController.text.trim(),
        "updatedAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note updated successfully")),
      );

       Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            NotePage(catId: widget.catId),
                      ),
                    );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating note: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Note")),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    CustomTextForm(
                      controller: titleController,
                      hintText: "Edit note title",
                     
                    ),
                    const SizedBox(height: 15),
                    CustomTextForm(
                      controller: contentController,
                      hintText: "Edit note content",
                    ),
                    const SizedBox(height: 20),
                    CustomAuthButton(
                      text: "Update Note",
                      bgcolor: Colors.orange,
                      onPress: editNote,
                    ),
                    const SizedBox(height: 20),
                    Text("Old title: ${widget.oldTitle}"),
                    if (widget.oldContent != null &&
                        widget.oldContent!.isNotEmpty)
                      Text("Old content: ${widget.oldContent}"),
                  ],
                ),
        ),
      ),
    );
  }
}
