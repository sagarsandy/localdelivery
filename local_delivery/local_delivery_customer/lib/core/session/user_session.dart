import '../utils/firebase_service.dart';

/// Singleton that exposes the currently authenticated user's identity.
///
/// All cubits and the router use this instead of importing FirebaseService
/// or firebase_auth directly. If authentication is swapped (e.g. to a custom
/// backend), only this file and FirebaseService need to change — cubits are
/// untouched.
class UserSession {
  UserSession._();
  static final UserSession instance = UserSession._();

  /// UID of the signed-in user, or null if not authenticated.
  String? get userId => FirebaseService.instance.currentUserId;
  // String? get userId => "hO8cpKioP7dowMH2fjqe5ilaFzM2";

  /// Phone number of the signed-in user (e.g. "+919876543210"), or null.
  String? get phoneNumber => FirebaseService.instance.currentUser?.phoneNumber;
  // String? get phoneNumber => "1231231231";

  /// True when a user is currently signed in.
  bool get isLoggedIn => FirebaseService.instance.isLoggedIn;
  // bool get isLoggedIn => true;

  /// Stream that emits true/false as auth state changes.
  Stream<bool> get authStateStream =>
      FirebaseService.instance.authStateChanges.map((user) => user != null);

  /// Signs the current user out. Delegates to FirebaseService.
  Future<void> signOut() => FirebaseService.instance.signOut();
}
