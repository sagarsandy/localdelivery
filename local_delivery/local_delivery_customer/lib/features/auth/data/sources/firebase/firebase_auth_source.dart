import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../dto/user_dto.dart';
import '../auth_remote_source.dart';

class FirebaseAuthSource implements AuthRemoteSource {
  FirebaseAuthSource()
      : _auth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  // Stored between sendOtp and verifyOtp calls.
  String? _verificationId;

  @override
  Future<void> sendOtp({required String phone}) async {
    final completer = Completer<void>();
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Android auto-verification
        await _auth.signInWithCredential(credential);
        if (!completer.isCompleted) completer.complete();
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        if (!completer.isCompleted) completer.complete();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
    return completer.future;
  }

  @override
  Future<void> verifyOtp({required String otp}) async {
    if (_verificationId == null) {
      throw FirebaseAuthException(
        code: 'session-expired',
        message: 'Session expired. Please request a new OTP.',
      );
    }
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );
    await _auth.signInWithCredential(credential);
  }

  @override
  Future<String?> getProfileName({required String userId}) async {
    final doc = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .get();
    if (!doc.exists || doc.data() == null) return null;
    final name = doc.data()!['name'] as String?;
    return (name?.isEmpty ?? true) ? null : name;
  }

  @override
  Future<void> saveProfileName({
    required String userId,
    required String name,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .set({'name': name.trim()}, SetOptions(merge: true));
  }

  @override
  Future<UserDto?> fetchUserProfile({required String userId}) async {
    final doc = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .get();
    if (!doc.exists || doc.data() == null) return null;
    return UserDto.fromFirestore(doc);
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .update(data);
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
