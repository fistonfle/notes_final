import '../repositories/note_repository.dart';

class UpdateNoteUseCase {
  UpdateNoteUseCase(this.repository);
  
  final NoteRepository repository;

  Future<void> call(String id, String text) {
    return repository.updateNote(id, text);
  }
}
