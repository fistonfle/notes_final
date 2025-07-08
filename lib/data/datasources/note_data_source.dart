import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/note.dart';

abstract class NoteDataSource {
  Future<List<Note>> fetchNotes(String userId);
  Future<void> addNote(String text, String userId);
  Future<void> updateNote(String id, String text);
  Future<void> deleteNote(String id);
}

class FirebaseNoteDataSource implements NoteDataSource {
  FirebaseNoteDataSource({required this.firestore});
  
  final FirebaseFirestore firestore;

  @override
  Future<List<Note>> fetchNotes(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('notes')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Note(
          id: doc.id,
          text: data['text'] ?? '',
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          updatedAt: (data['updatedAt'] as Timestamp).toDate(),
          userId: data['userId'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  @override
  Future<void> addNote(String text, String userId) async {
    try {
      final now = DateTime.now();
      await firestore.collection('notes').add({
        'text': text,
        'userId': userId,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  @override
  Future<void> updateNote(String id, String text) async {
    try {
      await firestore.collection('notes').doc(id).update({
        'text': text,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await firestore.collection('notes').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }
}
