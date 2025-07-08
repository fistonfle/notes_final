import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  SignInUseCase(this.repository);
  
  final AuthRepository repository;

  Future<User> call(String email, String password) {
    return repository.signInWithEmailAndPassword(email, password);
  }
}
