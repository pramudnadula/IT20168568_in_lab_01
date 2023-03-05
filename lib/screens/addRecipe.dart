import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ViewAllRecipe.dart';

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final _formKey = GlobalKey<FormState>();
  Future<void> taskAdd() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    //uploading to cloudfirestore
    await firebaseFirestore.collection("recipes").doc().set({
      "recipeName": recipeName.text,
      "description": description.text,
      "ingredients": ingredients.text, // set isCompleted field to false
    }).whenComplete(() => {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HomeScreen())),
          showSnackBar("Recipe added successfully", const Duration(seconds: 2))
        });
  }

  //snackbar for  showing error
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  TextEditingController recipeName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController ingredients = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Recipe Name',
                ),
                controller: recipeName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a Recipe Name';
                  }
                  return null;
                },
              ),
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Recipe description',
                ),
                controller: description,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a Recipe description';
                  }
                  return null;
                },
              ),
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Recipe ingredients',
                ),
                controller: ingredients,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a Recipe ingredients';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // add button validation to prevent accidental addition of empty task
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Add Task"),
                            content: const Text(
                                "Are you sure you want to add this Recipe?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  taskAdd();
                                },
                                child: const Text("Add"),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showSnackBar("Please Enter required fields",
                          const Duration(seconds: 2));
                    }
                  },
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
