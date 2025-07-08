import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  SignUpUseCase(this.repository);
  
  final AuthRepository repository;

  Future<User> call(String email, String password) {
    return repository.createUserWithEmailAndPassword(email, password);
  }
}
