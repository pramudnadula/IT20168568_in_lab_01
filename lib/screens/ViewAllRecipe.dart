import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_lab_01_it20168568/screens/viewOneRecipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/recipeModel.dart';
import 'addRecipe.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe> tasks = [];

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  // fetch data from collection
  @override
  Future<List<Recipe>> fetchRecords() async {
    var records = await FirebaseFirestore.instance.collection('recipes').get();
    return mapRecords(records);
  }

  List<Recipe> mapRecords(QuerySnapshot<Object?>? records) {
    var _list = records?.docs
        .map(
          (task) => Recipe(
            id: task.id,
            recipeName: task['recipeName'],
            description: task["description"],
            ingredients: task["ingredients"],
          ),
        )
        .toList();

    return _list ?? [];
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Recipe List'),
          actions: [
            IconButton(
              onPressed: () {
                logout(context);
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: Scrollbar(
          isAlwaysShown: true,
          child: SizedBox(
            width: width * 1,
            height: height * 1,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('recipes').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Recipe> data = mapRecords(snapshot.data);
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: height * 0.20,
                        child: Card(
                          color: Colors.blue.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.redAccent,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 2),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text(
                                                        "Recipe Name :  ",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    Text(
                                                      data[index].recipeName,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Text(
                                                        "Recipe Description :  ",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    Text(
                                                      data[index].description,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Text(
                                                        "Recipe Ingredients :  ",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    Text(
                                                      data[index].ingredients,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                      child: Text('View'),
                                                      onPressed: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ViewOneRecipeScreen(
                                                                          id: data[index]
                                                                              .id,
                                                                        )));
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Delete Task Confirmation'),
                                                              content: const Text(
                                                                  'Are you sure you want to delete this Recipe?'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              false),
                                                                  child:
                                                                      const Text(
                                                                          'No'),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'recipes')
                                                                        .doc(data[index]
                                                                            .id)
                                                                        .delete();
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            true);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Yes'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Text("Delete"),
                                                      style: ButtonStyle(
                                                        textStyle:
                                                            MaterialStateProperty
                                                                .all(
                                                          const TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                          Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddRecipe()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
