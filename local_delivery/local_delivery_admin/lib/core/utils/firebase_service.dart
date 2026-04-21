import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseAuth get auth => FirebaseAuth.instance;

  User? get currentUser => auth.currentUser;
  bool get isLoggedIn => currentUser != null;
  String? get currentUserId => currentUser?.uid;

  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<void> signOut() => auth.signOut();

  String? _verificationId;
  String? get verificationId => _verificationId;
  void setVerificationId(String id) => _verificationId = id;
}
