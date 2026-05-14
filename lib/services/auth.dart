import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends ChangeNotifier {
  static final Auth _instance = Auth._internal();
  factory Auth() => _instance;
  Auth._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? _username;
  final List<String> _takenUsernames = ['traveler', 'globetrotter', 'explorer123', 'admin'];

  User? get currentUser => _firebaseAuth.currentUser;
  String get username => _username ?? currentUser?.email?.split('@')[0] ?? 'explorer';
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //Sign in with email and password
  Future<void> createUser({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    notifyListeners();
  }

  //Login

  Future<void> signIn({required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    notifyListeners();
  }

  //Sign out

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }

  Future<void> updateDisplayName(String name) async {
    await _firebaseAuth.currentUser?.updateDisplayName(name);
    await _firebaseAuth.currentUser?.reload();
    notifyListeners();
  }

  bool isUsernameAvailable(String username) {
    final sanitized = username.replaceAll(' ', '').toLowerCase();
    return !_takenUsernames.contains(sanitized) || sanitized == _username;
  }

  List<String> suggestUsernames(String username) {
    final sanitized = username.replaceAll(' ', '').toLowerCase();
    return [
      '${sanitized}_traveler',
      '${sanitized}_2026',
      'the_$sanitized',
      '${sanitized}_x',
    ].where((s) => !_takenUsernames.contains(s)).toList();
  }

  Future<void> updateUsername(String username) async {
    final sanitized = username.replaceAll(' ', '').toLowerCase();
    if (!isUsernameAvailable(sanitized)) {
      throw Exception('Username already taken');
    }
    _username = sanitized;
    notifyListeners();
  }
}
