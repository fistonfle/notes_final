import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.dataSource});
  
  final AuthDataSource dataSource;

  @override
  Future<User?> getCurrentUser() {
    return dataSource.getCurrentUser();
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) {
    return dataSource.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<User> createUserWithEmailAndPassword(String email, String password) {
    return dataSource.createUserWithEmailAndPassword(email, password);
  }

  @override
  Future<void> signOut() {
    return dataSource.signOut();
  }
}
