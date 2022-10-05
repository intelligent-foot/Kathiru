import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{

//KEYS

static String userLoggedInKey = "ISLOGGEDIN";
static String userNameKey = "USERNAMEKEY";
static String userEmailKey = "USEREMAILKEY";


//saving data to SF
 static Future<bool> saveUserLoggedInStatus(
      bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }
  static Future<bool> saveUserEmailSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmailKey);
  }

//GETTING data from SF
 static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

}