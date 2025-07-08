import '../entities/note.dart';

abstract class NoteRepository {
  Future<List<Note>> fetchNotes(String userId);
  Future<void> addNote(String text, String userId);
  Future<void> updateNote(String id, String text);
  Future<void> deleteNote(String id);
}
