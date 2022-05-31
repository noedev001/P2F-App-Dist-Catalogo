import 'package:distribuidoraeye/general/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future loginFacebook(String email, String password, String nombre, String foto,
    String token) async {
  try {
    var url = Uri.parse(GloblaURL().urlGlobal() + 'login_facebook.php');

    final response = await http.post(url, body: {
      'email': email,
      'password': password,
      'nombre': nombre,
      'foto': foto,
      'token': token
    });
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      return jsonData;
    } else {
      throw Exception("Fallo la Conexión");
    }
  } catch (e) {
    print("apiiiiiiiii");
    print(e);
    //print("apiiiiiiiii");
  }
}
