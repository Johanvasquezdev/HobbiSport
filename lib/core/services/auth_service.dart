import 'package:firebase_auth/firebase_auth.dart';

import '../error/exceptions.dart';

abstract class AuthService {
  String? get currentUserId;
  Future<String> ensureUserId();
}

class AuthServiceImpl implements AuthService {
  AuthServiceImpl(this._auth);

  final FirebaseAuth _auth;

  @override
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  Future<String> ensureUserId() async {
    final user = _auth.currentUser;
    if (user != null) return user.uid;

    try {
      final result = await _auth.signInAnonymously();
      final uid = result.user?.uid;
      if (uid == null || uid.isEmpty) {
        throw const AuthException('Unable to create anonymous user');
      }
      return uid;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication failed');
    }
  }
}
