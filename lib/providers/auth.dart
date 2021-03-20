import 'dart:convert';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  static String _token;
  DateTime _expiryDate;
  String _userid;
  Timer authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null &&
          _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) 
        ) {
      return _token;
    }
    return null;
  }

  String get userid {
    return _userid;
  }

  Future<void> authenticate(
      String email, String password, String urlSigment) async {
    try {
      String url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSigment?key=AIzaSyAaCLSIxwTGZJ9OuBFMGZz_f4UMNWaUuLM';
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message'].toString());
      }
      _token = responseData['idToken'];
      _userid = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userid': _userid,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate=DateTime.parse(extractedUserData['expiryDate']);
  if(expiryDate.isBefore(DateTime.now())){
    return false;
  }
  _token=extractedUserData['token'];
  _userid=extractedUserData['userid'];
  _expiryDate=expiryDate;
notifyListeners();
autoLogout();
return true;
  }


  Future<void> logOut()async {
    _token = null;
    _userid = null;
    _expiryDate = null;
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    final prefs =await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();

  }

  void autoLogout() {
    if (authTimer != null) {
      authTimer.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: timeToExpire), logOut);
  }
}
