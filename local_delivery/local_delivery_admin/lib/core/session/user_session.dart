import '../utils/firebase_service.dart';

class UserSession {
  UserSession._();
  static final UserSession instance = UserSession._();

  String? get userId => FirebaseService.instance.currentUserId;
  String? get phoneNumber => FirebaseService.instance.currentUser?.phoneNumber;
  bool get isLoggedIn => FirebaseService.instance.isLoggedIn;

  Stream<bool> get authStateStream =>
      FirebaseService.instance.authStateChanges.map((user) => user != null);

  Future<void> signOut() => FirebaseService.instance.signOut();
}
