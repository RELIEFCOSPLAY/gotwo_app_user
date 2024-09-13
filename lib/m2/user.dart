import 'package:shared_preferences/shared_preferences.dart';

class User{
  static Future <bool?> getsignin() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("Sign-in");
  }
  
  static Future setsigin(bool signin) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("Sign-in", signin);
  }
}