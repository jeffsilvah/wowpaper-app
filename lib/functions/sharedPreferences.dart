import 'package:shared_preferences/shared_preferences.dart';

void setItem({key, value}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  preferences.setStringList(key, value);
}

Future<List<String>> getItem({key}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  return preferences.getStringList(key);
}