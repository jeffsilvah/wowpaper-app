import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future request({url}) async {
  var response = await http.get(url);
  var requestBody;

  if(response.statusCode == 200){
    requestBody = convert.jsonDecode(response.body);
  }

  return requestBody;
}