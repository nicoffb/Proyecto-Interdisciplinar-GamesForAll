/*class User {
  final String name;
  final String email;
  final String accessToken;
  final String? avatar;

  User({required this.name, required this.email, required this.accessToken, this.avatar});

  @override
  String toString() => 'User { name: $name, email: $email}';
}*/

import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../models/login.dart';

class User {
  String? id;
  String? username;
  String? avatar;
  String? fullName;

  User({this.id, this.username, this.avatar, this.fullName});

  User.fromLoginResponse(LoginResponse response) {
    this.id = response.id;
    this.username = response.username;
    this.avatar = response.avatar;
    this.fullName = response.fullName;
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    avatar = json['avatar'];
    fullName = json['fullName'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    data['fullName'] = this.fullName;
    return data;
  }
}

//REQUEST
class UserRequest {
  String? username;
  String? password;
  String? verifyPassword;
  String? fullName;
  String? avatar;
  String? address;

  UserRequest(
      {this.username,
      this.password,
      this.verifyPassword,
      this.fullName,
      this.avatar,
      this.address});

  UserRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    verifyPassword = json['verifyPassword'];
    fullName = json['fullName'];
    avatar = json['avatar'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['verifyPassword'] = this.verifyPassword;
    data['fullName'] = this.fullName;
    data['avatar'] = this.avatar;
    data['address'] = this.address;
    return data;
  }
}
