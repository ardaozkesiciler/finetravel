import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  static final Auth _instance = Auth._internal();
  factory Auth() => _instance;
  Auth._internal() {
    _initUsername();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? _username;
  String? _avatarPath;
  final List<String> _takenUsernames = ['traveler', 'globetrotter', 'explorer123', 'admin'];

  Future<void> _initUsername() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid != null) {
      final prefs = await SharedPreferences.getInstance();
      _username = prefs.getString('username_$uid');
      _avatarPath = prefs.getString('avatarPath_$uid');
      if (_username != null || _avatarPath != null) {
        notifyListeners();
      }
    }

    _firebaseAuth.authStateChanges().listen((User? user) async {
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        _username = prefs.getString('username_${user.uid}');
        if (_username == null) {
          _username = user.email?.split('@')[0] ?? 'explorer';
          await prefs.setString('username_${user.uid}', _username!);
        }
        _avatarPath = prefs.getString('avatarPath_${user.uid}');
        notifyListeners();
      } else {
        _username = null;
        _avatarPath = null;
        notifyListeners();
      }
    });
  }

  User? get currentUser => _firebaseAuth.currentUser;
  String get username => _username ?? currentUser?.email?.split('@')[0] ?? 'explorer';
  String? get avatarPath => _avatarPath;
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

  Future<void> updateUsername(String newUsername) async {
    final sanitized = newUsername.replaceAll(' ', '').toLowerCase();
    if (!isUsernameAvailable(sanitized)) {
      throw Exception('Username already taken');
    }
    _username = sanitized;
    
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username_$uid', _username!);
    }
    
    notifyListeners();
  }

  Future<void> updateAvatar(String path) async {
    _avatarPath = path;
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatarPath_$uid', _avatarPath!);
    }
    notifyListeners();
  }
}
