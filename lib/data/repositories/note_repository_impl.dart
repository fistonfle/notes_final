import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_data_source.dart';

class NoteRepositoryImpl implements NoteRepository {
  NoteRepositoryImpl({required this.dataSource});
  
  final NoteDataSource dataSource;

  @override
  Future<List<Note>> fetchNotes(String userId) {
    return dataSource.fetchNotes(userId);
  }

  @override
  Future<void> addNote(String text, String userId) {
    return dataSource.addNote(text, userId);
  }

  @override
  Future<void> updateNote(String id, String text) {
    return dataSource.updateNote(id, text);
  }

  @override
  Future<void> deleteNote(String id) {
    return dataSource.deleteNote(id);
  }
}
