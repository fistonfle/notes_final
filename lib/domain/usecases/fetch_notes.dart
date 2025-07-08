import '../entities/note.dart';
import '../repositories/note_repository.dart';

class FetchNotesUseCase {
  FetchNotesUseCase(this.repository);
  
  final NoteRepository repository;

  Future<List<Note>> call(String userId) {
    return repository.fetchNotes(userId);
  }
}
