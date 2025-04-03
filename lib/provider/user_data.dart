import 'package:flutter/foundation.dart';

class UserData with ChangeNotifier {
  String _userID = '';
  String _userType = '';
  String _lastName = '';
  String _firstName = '';
  String _middleName = '';
  String _suffix = '';
  String _email = '';
  String _program = '';
  String _yearLevel = '';
  String _contactNumber = '';
  String _picture = '';


  String get userID => _userID;
  String get userType => _userType;
  String get lastName => _lastName;
  String get firstName => _firstName;
  String get middleName => _middleName;
  String get suffix => _suffix;
  String get email => _email;
  String get program => _program;
  String get yearLevel => _yearLevel;
  String get contactNumber => _contactNumber;
  String get picture => _picture;


  // Setters to update the data
  void setUserData({
    required String userID,
    required String userType,
    required String lastName,
    required String firstName,
    required String middleName,
    required String suffix,
    required String email,
    required String program,
    required String yearLevel,
    required String contactNumber,
    required String picture,

  }) {
    _userID = userID;
    _userType = userType;
    _lastName = lastName;
    _firstName = firstName;
    _middleName = middleName;
    _suffix = suffix;
    _email = email;
    _program = program;
    _yearLevel = yearLevel;
    _contactNumber = contactNumber;
    _picture = picture;
    notifyListeners(); // Notify listeners about data change
  }
 
 void updateUser({
  required String firstName,
  required String lastName,
  required String middleName,
  required String suffix,
  required String contactNumber,
  required String? program,  // Allow null, but handle it properly
  required String? yearLevel,
}) {
  _firstName = firstName;
  _lastName = lastName;
  _middleName = middleName;
  _suffix = suffix;
  _contactNumber = contactNumber;
  _program = program ?? _program;  // Retain old value if null
  _yearLevel = yearLevel ?? _yearLevel;
  notifyListeners();
}



}

