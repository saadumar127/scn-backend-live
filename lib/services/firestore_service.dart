import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  DocumentReference<Map<String, dynamic>>? get _userDoc {
    final uid = currentUserId;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid);
  }

  // 🔥 Ensure profile exists
  Future<void> ensureUserProfileExists() async {
    final user = _auth.currentUser;
    final userDoc = _userDoc;

    if (user == null || userDoc == null) return;

    final doc = await userDoc.get();
    if (doc.exists) return;

    await userDoc.set({
      'name': user.displayName ?? 'SCN User',
      'email': user.email ?? '',
      'photoUrl': user.photoURL ?? '',
      'provider': user.providerData.isNotEmpty
          ? user.providerData.first.providerId
          : 'unknown',
      'educationLevel': '',
      'selectedField': '',
      'percentage': 0.0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // 🔥 Sync auth → firestore
  Future<void> syncCurrentUserToProfile() async {
    final user = _auth.currentUser;
    final userDoc = _userDoc;

    if (user == null || userDoc == null) return;

    await userDoc.set({
      'name': user.displayName ?? 'SCN User',
      'email': user.email ?? '',
      'photoUrl': user.photoURL ?? '',
      'provider': user.providerData.isNotEmpty
          ? user.providerData.first.providerId
          : 'unknown',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // 🔥 Save profile data
  Future<void> saveUserProfile({
    required String name,
    required String email,
    required String educationLevel,
    required String selectedField,
    required double percentage,
  }) async {
    final userDoc = _userDoc;
    if (userDoc == null) return;

    await userDoc.set({
      'name': name,
      'email': email,
      'educationLevel': educationLevel,
      'selectedField': selectedField,
      'percentage': percentage,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // 🔥 Update profile
  Future<void> updateUserProfile({
    required String name,
    required String email,
  }) async {
    final user = _auth.currentUser;
    final userDoc = _userDoc;

    if (user == null || userDoc == null) return;

    await user.updateDisplayName(name);
    await user.reload();

    await userDoc.set({
      'name': name,
      'email': email,
      'photoUrl': user.photoURL ?? '',
      'provider': user.providerData.isNotEmpty
          ? user.providerData.first.providerId
          : 'unknown',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // 🔥 SAVE QUIZ RESULT (FINAL)
  Future<void> saveQuizResult({
    required String educationLevel,
    required String selectedField,
    required String recommendedField,
    required List<Map<String, dynamic>> rankedFields,
  }) async {
    final userDoc = _userDoc;
    if (userDoc == null) return;

    await userDoc.collection('quizResults').add({
      'educationLevel': educationLevel,
      'selectedField': selectedField,
      'recommendedField': recommendedField,
      'rankedFields': rankedFields,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 🔥 SAVE CHAT HISTORY (FINAL)
  Future<void> saveChatMessage({
    required String educationLevel,
    required String selectedField,
    required String userMessage,
    required String botReply,
  }) async {
    final userDoc = _userDoc;
    if (userDoc == null) return;

    await userDoc.collection('chatHistory').add({
      'educationLevel': educationLevel,
      'selectedField': selectedField,
      'userMessage': userMessage,
      'botReply': botReply,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 🔥 PROFILE STREAM
  Stream<Map<String, dynamic>?> getUserProfileStream() {
    final userDoc = _userDoc;
    if (userDoc == null) {
      return Stream.value(null);
    }

    return userDoc.snapshots().map((doc) => doc.data());
  }

  // 🔥 QUIZ HISTORY STREAM
  Stream<List<Map<String, dynamic>>> getQuizHistoryStream() {
    final userDoc = _userDoc;
    if (userDoc == null) {
      return Stream.value([]);
    }

    return userDoc
        .collection('quizResults')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList());
  }

  // 🔥 CHAT HISTORY STREAM
  Stream<List<Map<String, dynamic>>> getChatHistoryStream() {
    final userDoc = _userDoc;
    if (userDoc == null) {
      return Stream.value([]);
    }

    return userDoc
        .collection('chatHistory')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList());
  }
}