import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Singleton wrapper around Firebase services.
///
/// This is the single integration point for Firebase in the app.
/// All repository implementations and cubits use this class — never
/// import firebase_auth or cloud_firestore directly outside of this file
/// and the repository implementations in data/repositories/.
///
/// To swap Firebase for another backend later:
///   1. Replace this class with a new service wrapper (e.g. CustomBackendService)
///   2. Update the repository implementations in each feature's data/repositories/
///   3. No domain layer, cubit, or use case files need to change.
class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseAuth get auth => FirebaseAuth.instance;

  // Auth shortcuts
  User? get currentUser => auth.currentUser;
  bool get isLoggedIn => currentUser != null;
  String? get currentUserId => currentUser?.uid;

  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<void> signOut() => auth.signOut();

  // Stores the verificationId between signInWithOtp and verifyOtp calls.
  // Firebase phone auth requires this to be threaded through.
  String? _verificationId;
  String? get verificationId => _verificationId;
  void setVerificationId(String id) => _verificationId = id;
}
