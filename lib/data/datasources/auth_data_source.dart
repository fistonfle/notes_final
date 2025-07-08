import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

abstract class AuthDataSource {
  Future<User?> getCurrentUser();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}

class FirebaseAuthDataSource implements AuthDataSource {
  FirebaseAuthDataSource({required this.firebaseAuth, required this.firestore});
  
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  @override
  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) return null;
      
      return User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
      );
    } catch (e) {
      print('getCurrentUser error: $e');
      return null;
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception('Sign in failed - no user returned');
      }
      
      final user = User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
      );
      
      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      throw Exception(_getErrorMessage(e.code));
    } catch (e) {
      print('Sign in error: $e');
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception('Account creation failed - no user returned');
      }
      
      final user = User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
      );
      
      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      throw Exception(_getErrorMessage(e.code));
    } catch (e) {
      print('Account creation error: $e');
      throw Exception('Account creation failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      throw Exception('Sign out failed: $e');
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'The password is too weak';
      case 'email-already-in-use':
        return 'An account already exists for this email';
      case 'invalid-email':
        return 'The email address is invalid';
      case 'user-not-found':
        return 'No user found for this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'too-many-requests':
        return 'Too many requests. Try again later';
      case 'invalid-credential':
        return 'The provided credentials are invalid';
      case 'user-disabled':
        return 'This user account has been disabled';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
