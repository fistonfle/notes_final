import 'package:equatable/equatable.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class FetchNotesRequested extends NotesEvent {
  final String userId;

  const FetchNotesRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddNoteRequested extends NotesEvent {
  final String text;
  final String userId;

  const AddNoteRequested({required this.text, required this.userId});

  @override
  List<Object?> get props => [text, userId];
}

class UpdateNoteRequested extends NotesEvent {
  final String id;
  final String text;

  const UpdateNoteRequested({required this.id, required this.text});

  @override
  List<Object?> get props => [id, text];
}

class DeleteNoteRequested extends NotesEvent {
  final String id;

  const DeleteNoteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
