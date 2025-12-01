import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalUser {
  final String uid;
  final String email;
  final String displayName;

  LocalUser({required this.uid, required this.email, required this.displayName});

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
  };

  factory LocalUser.fromJson(Map<String, dynamic> json) => LocalUser(
    uid: json['uid'],
    email: json['email'],
    displayName: json['displayName'],
  );
}

class LocalAuthService {
  static const String _userKey = 'current_user';
  static const String _usersKey = 'registered_users';
  
  LocalUser? _currentUser;
  LocalUser? get currentUser => _currentUser;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      _currentUser = LocalUser.fromJson(jsonDecode(userData));
    }
  }

  Future<LocalUser> signInWithEmail(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersData = prefs.getString(_usersKey) ?? '{}';
    final users = Map<String, dynamic>.from(jsonDecode(usersData));
    
    if (users.containsKey(email) && users[email] == password) {
      _currentUser = LocalUser(
        uid: email.hashCode.toString(),
        email: email,
        displayName: email.split('@')[0],
      );
      await prefs.setString(_userKey, jsonEncode(_currentUser!.toJson()));
      return _currentUser!;
    }
    throw Exception('Email ou mot de passe incorrect');
  }

  Future<LocalUser> createAccount(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersData = prefs.getString(_usersKey) ?? '{}';
    final users = Map<String, dynamic>.from(jsonDecode(usersData));
    
    if (users.containsKey(email)) {
      throw Exception('Un compte existe déjà avec cet email');
    }
    
    users[email] = password;
    await prefs.setString(_usersKey, jsonEncode(users));
    
    return signInWithEmail(email, password);
  }

  Future<void> signOut() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}