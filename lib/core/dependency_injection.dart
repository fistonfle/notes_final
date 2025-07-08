import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/datasources/auth_data_source.dart';
import '../data/datasources/note_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/note_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/note_repository.dart';
import '../domain/usecases/add_note.dart';
import '../domain/usecases/delete_note.dart';
import '../domain/usecases/fetch_notes.dart';
import '../domain/usecases/sign_in.dart';
import '../domain/usecases/sign_out.dart';
import '../domain/usecases/sign_up.dart';
import '../domain/usecases/update_note.dart';
import '../presentation/bloc/auth_bloc.dart';
import '../presentation/bloc/notes_bloc.dart';

class DependencyInjection {
  // Data Sources
  static final AuthDataSource _authDataSource = FirebaseAuthDataSource(
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );

  static final NoteDataSource _noteDataSource = FirebaseNoteDataSource(
    firestore: FirebaseFirestore.instance,
  );

  // Repositories
  static final AuthRepository _authRepository = AuthRepositoryImpl(
    dataSource: _authDataSource,
  );

  static final NoteRepository _noteRepository = NoteRepositoryImpl(
    dataSource: _noteDataSource,
  );

  // Use Cases
  static final SignInUseCase _signInUseCase = SignInUseCase(_authRepository);
  static final SignUpUseCase _signUpUseCase = SignUpUseCase(_authRepository);
  static final SignOutUseCase _signOutUseCase = SignOutUseCase(_authRepository);
  static final FetchNotesUseCase _fetchNotesUseCase = FetchNotesUseCase(_noteRepository);
  static final AddNoteUseCase _addNoteUseCase = AddNoteUseCase(_noteRepository);
  static final UpdateNoteUseCase _updateNoteUseCase = UpdateNoteUseCase(_noteRepository);
  static final DeleteNoteUseCase _deleteNoteUseCase = DeleteNoteUseCase(_noteRepository);

  // BLoCs
  static AuthBloc createAuthBloc() {
    return AuthBloc(
      signInUseCase: _signInUseCase,
      signUpUseCase: _signUpUseCase,
      signOutUseCase: _signOutUseCase,
      authRepository: _authRepository,
    );
  }

  static NotesBloc createNotesBloc() {
    return NotesBloc(
      fetchNotesUseCase: _fetchNotesUseCase,
      addNoteUseCase: _addNoteUseCase,
      updateNoteUseCase: _updateNoteUseCase,
      deleteNoteUseCase: _deleteNoteUseCase,
    );
  }
}
