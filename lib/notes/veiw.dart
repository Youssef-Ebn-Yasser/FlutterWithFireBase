import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/notes/add.dart';
import 'package:firebase/notes/edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  final String catId; // ✅ lowercase for clarity
  const NotePage({super.key, required this.catId});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<QueryDocumentSnapshot> notesList = [];
  bool isLoading = true;

  void _signOut() async {
    await _auth.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
  }

  Future<void> getNotes() async {
    try {
      setState(() => isLoading = true);

      QuerySnapshot data = await FirebaseFirestore.instance
          .collection('Categories')
          .doc(widget.catId)
          .collection("note") // ✅ changed from "note" → "Notes"
          .get();

      notesList = data.docs;
    } catch (e) {
      debugPrint("Error fetching notes: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNote(catId: widget.catId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _signOut),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notesList.isEmpty
          ? const Center(
              child: Text(
                "No notes available yet.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : GridView.builder(
              itemCount: notesList.length,
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 150,
              ),
              itemBuilder: (context, i) {
                final note = notesList[i];
                return InkWell(
                  onLongPress: () async {
                    await FirebaseFirestore.instance
                        .collection('Categories')
                        .doc(widget.catId)
                        .collection('note')
                        .doc(note.id)
                        .delete();
                    getNotes(); // refresh after delete
                  },
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditNote(
                          noteId: note.id,
                          oldTitle: note['name'] ?? 'Untitled',
                          oldContent: note['content'] ?? '',
                          catId: widget.catId,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note['name'] ?? 'Untitled',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Text(
                              (note.data() as Map<String, dynamic>?)
                                          ?.containsKey('content') ==
                                      true
                                  ? (note['content'] ?? 'no content')
                                  : 'no content',
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
