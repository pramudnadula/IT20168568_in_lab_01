// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// import '../models/recipeModel.dart';

// class ViewOneRecipeUpdateScreen extends StatefulWidget {
//   final String id;

//   const ViewOneRecipeUpdateScreen({Key? key, required this.id}) : super(key: key);

//   @override
//   _ViewOneRecipeUpdateScreenState createState() =>
//       _ViewOneRecipeUpdateScreenState();
// }

// class _ViewOneRecipeUpdateScreenState
//     extends State<ViewOneRecipeUpdateScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _ingredientsController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Recipe"),
//       ),
//       body: Container(
//         child: StreamBuilder<Recipe>(
//             stream: FirebaseFirestore.instance
//                 .collection('recipes')
//                 .doc(widget.id)
//                 .snapshots()
//                 .map((doc) => Recipe.fromDocumentSnapshot(doc)),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(child: CircularProgressIndicator());
//               } else {
//                 Recipe data = snapshot.data!;

//                 _nameController.text = data.recipeName;
//                 _descriptionController.text = data.description;
//                 _ingredientsController.text = data.ingredients;
//                 return SingleChildScrollView(
//                   child: Column(
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: TextField(
//                           controller: _nameController,
//                           decoration: InputDecoration(
//                             labelText: "name",
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: TextField(
//                           controller: _descriptionController,
//                           decoration: InputDecoration(
//                             labelText: "description",
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: TextField(
//                           controller: _ingredientsController,
//                           decoration: InputDecoration(
//                             labelText: "ingredients",
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             await FirebaseFirestore.instance
//                                 .collection('question')
//                                 .doc(widget.id)
//                                 .update({
//                               'question': _nameController.text,
//                               'answer':      _descriptionController.text,
//                             'ingredients':    _ingredientsController.text

//                             });

//                             Navigator.pop(context);
//                           },
//                           child: Text("Save"),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//             }),
//       ),
//     );
//   }
// }
