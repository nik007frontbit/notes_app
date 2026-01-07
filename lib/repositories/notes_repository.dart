import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/notes/models/note_model.dart';

class NotesRepository {
  final FirebaseFirestore _firestore;

  NotesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _notesCollection => _firestore.collection('notes');

  Stream<List<NoteModel>> getNotes(String userId) {
    return _notesCollection
        .where('user_id', isEqualTo: userId)
        .orderBy('updated_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              NoteModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> addNote(NoteModel note) async {
    await _notesCollection.add(note.toMap());
  }

  Future<void> updateNote(NoteModel note) async {
    await _notesCollection.doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String noteId) async {
    await _notesCollection.doc(noteId).delete();
  }
}
