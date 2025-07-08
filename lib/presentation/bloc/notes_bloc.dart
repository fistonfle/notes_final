import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/fetch_notes.dart';
import '../../domain/usecases/add_note.dart';
import '../../domain/usecases/update_note.dart';
import '../../domain/usecases/delete_note.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final FetchNotesUseCase fetchNotesUseCase;
  final AddNoteUseCase addNoteUseCase;
  final UpdateNoteUseCase updateNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;

  NotesBloc({
    required this.fetchNotesUseCase,
    required this.addNoteUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
  }) : super(NotesInitial()) {
    on<FetchNotesRequested>(_onFetchNotesRequested);
    on<AddNoteRequested>(_onAddNoteRequested);
    on<UpdateNoteRequested>(_onUpdateNoteRequested);
    on<DeleteNoteRequested>(_onDeleteNoteRequested);
  }

  Future<void> _onFetchNotesRequested(
    FetchNotesRequested event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());
    try {
      final notes = await fetchNotesUseCase(event.userId);
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onAddNoteRequested(
    AddNoteRequested event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await addNoteUseCase(event.text, event.userId);
      emit(const NotesOperationSuccess('Note added successfully'));
      add(FetchNotesRequested(event.userId));
    } catch (e) {
      emit(NotesError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onUpdateNoteRequested(
    UpdateNoteRequested event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await updateNoteUseCase(event.id, event.text);
      emit(const NotesOperationSuccess('Note updated successfully'));
      // Get current user ID from the current state
      if (state is NotesLoaded) {
        final currentNotes = (state as NotesLoaded).notes;
        if (currentNotes.isNotEmpty) {
          add(FetchNotesRequested(currentNotes.first.userId));
        }
      }
    } catch (e) {
      emit(NotesError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onDeleteNoteRequested(
    DeleteNoteRequested event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await deleteNoteUseCase(event.id);
      emit(const NotesOperationSuccess('Note deleted successfully'));
      // Get current user ID from the current state
      if (state is NotesLoaded) {
        final currentNotes = (state as NotesLoaded).notes;
        if (currentNotes.isNotEmpty) {
          add(FetchNotesRequested(currentNotes.first.userId));
        }
      }
    } catch (e) {
      emit(NotesError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
