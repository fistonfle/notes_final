import '../repositories/note_repository.dart';

class AddNoteUseCase {
  AddNoteUseCase(this.repository);
  
  final NoteRepository repository;

  Future<void> call(String text, String userId) {
    return repository.addNote(text, userId);
  }
}
