import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googlenote/model/note_model.dart';

class FirebaseService {
  final CollectionReference _notesCollection = FirebaseFirestore.instance.collection('user');

  Future<void> addNoteToFirestore(AddNote) async {
    try {
      await _notesCollection.add(AddNote.toJson());
    } catch (e) {
      print('Error adding note to Firestore: $e');
    }
  }

  Future<void> updateNoteInFirestore(AddNote note) async {
    try {
      await FirebaseFirestore.instance.collection('user').doc(note.id).update({
        'title': note.title,
        'note': note.note,
        'color': note.color,
        'imagePaths': note.imagePaths,
        'backImage': note.backImage,
      });
    } catch (e) {
      print('Error updating note: $e');
    }
  }

  Stream<List<AddNote>> getNotesFromFirestore() {
    return _notesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return AddNote.fromJson(data);
      }).toList();
    });
  }

  Future<void> deleteNoteById(String noteId) async {
    await _notesCollection.doc(noteId).delete();
  }

  Future<AddNote?> getNoteById(String noteId) async {
    try {
      var docSnapshot = await _notesCollection.doc(noteId).get();
      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        data['id'] = docSnapshot.id;
        return AddNote.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting note by id: $e');
      return null;
    }
  }

  Future<void> updateNote(AddNote note) async {
    try {
      await _notesCollection.doc(note.id).update({
        'title': note.title,
        'note': note.note,
        'color': note.color,
        'imagePaths': note.imagePaths,
        'backImage': note.backImage,
        'isPinned': note.isPinned,
      });
    } catch (e) {
      print('Error updating note: $e');
    }
  }
}
