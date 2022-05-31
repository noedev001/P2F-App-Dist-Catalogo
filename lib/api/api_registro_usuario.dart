import 'package:distribuidoraeye/general/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future registroUser(String email, String password, String nombre,
    String apellido, String numero, String token) async {
  try {
    var url = Uri.parse(GloblaURL().urlGlobal() + 'registro_usuario.php');

    final response = await http.post(url, body: {
      'email': email,
      'password': password,
      'nombre': nombre,
      'apellidos': apellido,
      'numero': numero,
      'token': token,
    });
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      return jsonData;
    } else {
      throw Exception("Fallo la Conexión");
    }
  } catch (e) {
    print(e);
    print("apiiiiiiiii");
  }
}
