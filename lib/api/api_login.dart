import 'package:distribuidoraeye/general/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future loginUser(String email, String password, String token) async {
  var url = Uri.parse(GloblaURL().urlGlobal() + 'login.php');

  final response = await http.post(url,
      headers: {"accept": "Application/json"},
      body: {'email': email, 'password': password, 'token': token});

  var convertadDataJson = jsonDecode(response.body);
  return convertadDataJson;

  //print(response.body);

  /*var url = Uri.parse('http://192.168.100.127:8000/api/login');

  final response = await http.post(url,
      headers: {"accept": "Application/json"},
      body: {'email': email, 'password': password, 'token': token});

  var convertadDataJson = jsonDecode(response.body);
  return convertadDataJson;*/
}
