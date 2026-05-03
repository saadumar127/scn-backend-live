import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firestore_service.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '89447583523-v7agccr8pqbbu2g9kbjtmd3nl70n7sh8.apps.googleusercontent.com',
  );

  User? get currentUser => _auth.currentUser;

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirestoreService.instance.ensureUserProfileExists();
    await FirestoreService.instance.syncCurrentUserToProfile();

    return userCredential.user;
  }

  Future<User?> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await userCredential.user?.updateDisplayName(name);
    await userCredential.user?.reload();

    await FirestoreService.instance.ensureUserProfileExists();
    await FirestoreService.instance.syncCurrentUserToProfile();

    return _auth.currentUser;
  }

  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    await FirestoreService.instance.ensureUserProfileExists();
    await FirestoreService.instance.syncCurrentUserToProfile();

    return userCredential.user;
  }

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}