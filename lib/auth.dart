import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  CollectionReference get allUsers => _firestore.collection('users');
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> addUser({required String userId}) async {
    allUsers
      .doc(userId)
      .set({
        'finishedQuestions': [],
        'progress': 0
      });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password
    );
  }
  
  Future<void> createUser({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );
    
    await addUser(
      userId: _firebaseAuth.currentUser!.uid
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

final Auth auth = Auth();