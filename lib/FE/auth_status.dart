import 'package:flutter/material.dart';

bool isLoggedIn = false;

String? checkLogin(String username, String password) {
  if (username == 'admin' && password == '123') {
    isLoggedIn = true;
    return '/admin/dashboard';
  } else if (username == 'user' && password == '123') {
    isLoggedIn = true;
    return '/';
  } else {
    return null; // login failed
  }
}
