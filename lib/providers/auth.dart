import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../keys/firebase.dart' as keys;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticate(String email, String password, String specialUrl) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$specialUrl?key=${keys.firebaseAppKey}';
    try{
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if(responseData['error'] !=null){
        throw HttpException(responseData['error']['message']);
      }
    }
    catch (error){
      throw error;
    }

  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email,password,'signUp');
  }

  Future<void> signIn(String email,String password) async {
    return _authenticate(email,password,'signInWithPassword');
  }
}
