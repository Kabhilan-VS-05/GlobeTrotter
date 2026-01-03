import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String displayName);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> updateUserProfile(UserModel user);
}

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      
      return UserModel(
        id: currentUser.uid,
        email: currentUser.email ?? '',
        displayName: currentUser.displayName ?? userDoc.data()?['displayName'] ?? 'User',
        photoUrl: currentUser.photoURL,
        createdAt: currentUser.metadata.creationTime ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isEmailVerified: currentUser.emailVerified ?? false,
        preferences: List<String>.from(userDoc.data()?['preferences'] ?? []),
      );
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;
      await _saveUserToFirestore(user);

      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? 'User',
        photoUrl: user.photoURL,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isEmailVerified: user.emailVerified ?? false,
      );
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String displayName) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;
      await user.updateDisplayName(displayName);
      
      await _saveUserToFirestore(user, displayName: displayName);

      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: displayName,
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEmailVerified: user.emailVerified ?? false,
      );
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send reset email: $e');
    }
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update({
        'displayName': user.displayName,
        'photoUrl': user.photoUrl,
        'preferences': user.preferences,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.updateDisplayName(user.displayName);
        if (user.photoUrl != null) {
          await currentUser.updatePhotoURL(user.photoUrl);
        }
      }
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  Future<void> _saveUserToFirestore(User user, {String? displayName}) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'displayName': displayName ?? user.displayName ?? 'User',
      'photoUrl': user.photoURL,
      'emailVerified': user.emailVerified,
      'preferences': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
