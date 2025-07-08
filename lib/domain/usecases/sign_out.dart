import '../repositories/auth_repository.dart';

class SignOutUseCase {
  SignOutUseCase(this.repository);
  
  final AuthRepository repository;

  Future<void> call() {
    return repository.signOut();
  }
}
