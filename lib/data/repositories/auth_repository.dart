import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow/data/models/user_model.dart';
import 'package:flow/data/services/base_repository.dart';

class AuthRepository extends BaseRepository {
  Future<UserModel> signUp({
    required String fullName,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final formattedPhoneNumber = phoneNumber.replaceAll(
        RegExp(r'\s+'),
        "".trim(),
      );
      final UserCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (UserCredential.user == null) {
        throw 'Failed to create user';
      }
      // create the user model and save the user in the db firestore
      final user = UserModel(
        uid: auth.currentUser!.uid,
        username: username,
        fullName: fullName,
        email: email,
        phoneNumber: formattedPhoneNumber,
      );

      await saveUserData(user);
      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (UserCredential.user == null) {
        throw 'User not found';
      }
      final userData = await getUserData(UserCredential.user!.uid);
      return userData;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> saveUserData(UserModel user) async {
    try {
      firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      throw 'Failed to save user data';
    }
  }

  Future<UserModel> getUserData(String uid) async {
    try {
      final doc = await firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        throw 'user data not found';
      }
      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw 'Failed to save user data';
    }
  }
}
