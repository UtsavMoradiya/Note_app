// import 'dart:js';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../model/note_model.dart';
//
// class FirebaseService {
//   final CollectionReference _notesCollection = FirebaseFirestore.instance.collection('user');
//   Future<void> deleteNoteInFirestore(String noteId) async {
//     try {
//       await _notesCollection.doc(noteId).delete();
//     } catch (e) {
//       print("Error deleting note: $e");
//       // Handle errors as needed
//     }
//   }
//
//   getNotesFromFirestore() {
//     return _notesCollection.snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//         return AddNote.fromJson(data)
//           ..id = doc.id;
//       }).toList();
//     });
//   }
//   Future<List<AddNote>> searchNotes(String query) async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('your_notes_collection') // Change to your actual collection name
//           .where('title', isGreaterThanOrEqualTo: query)
//           .where('title', isLessThan: query + 'z') // Assuming case-insensitive search
//           .get();
//
//       List<AddNote> searchResults = querySnapshot.docs
//           .map((doc) => AddNote.fromJson(doc.data() as Map<String, dynamic>))
//           .toList();
//
//       return searchResults;
//     } catch (e) {
//       // Handle errors
//       print("Error searching notes: $e");
//       return [];
//     }
//   }
//   Future<void> addNoteToFirestore(AddNote user) async {
//     try {
//       if (user.title!.isNotEmpty || user.note!.isNotEmpty) {
//         await _notesCollection.add(user.toJson());
//       } else {
//         ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//           const SnackBar(content: Text("Empty note discarded"), duration: Duration(seconds: 1)),
//         );
//       }
//     } catch (e) {
//       print('Error adding note to Firestore: $e');
//     }
//   }
//
//   Future<void> updateNoteInFirestore(AddNote user) async {
//     try {
//       await _notesCollection.doc(user.id).update(user.toJson());
//     } catch (e) {
//       print('Error updating note in Firestore: $e');
//     }
//   }
// }