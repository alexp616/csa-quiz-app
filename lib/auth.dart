import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> addUser({required String userId}) async {
    FirebaseFirestore.instance.collection('users')
      .add({
        'sus1': 'susworked'
      });
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password
    );
  }
  
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );
    await addUser(userId: FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}