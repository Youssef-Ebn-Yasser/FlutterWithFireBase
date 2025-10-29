import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Categories/edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<QueryDocumentSnapshot> categoryList = [];
  bool isLoading = true;

  void _signOut() async {
    await _auth.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
  }

  getData() async {
    isLoading = true;
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('Categories')
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    categoryList.addAll(data.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).pushNamed("addcategory");
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _signOut),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: categoryList.length,
              padding: EdgeInsets.all(15),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 250,
              ),
              itemBuilder: (context, i) {
                return InkWell(
                  onLongPress: () async {
                    CollectionReference Categories = FirebaseFirestore.instance
                        .collection('Categories');
                    Categories.doc(categoryList[i].id)
                        .delete()
                        .then(
                          (value) => Navigator.of(
                            context,
                          ).pushReplacementNamed("homePage"),
                        )
                        .catchError(
                          (error) => print("Failed to delete category: $error"),
                        );
                  },

                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditCategory(
                          docId: categoryList[i].id,
                          oldName: categoryList[i]['CategoryName'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Image.asset("images/logo.png"),
                        SizedBox(height: 20),
                        Text(
                          categoryList[i]['CategoryName'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
