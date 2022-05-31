import 'dart:convert';
import 'package:distribuidoraeye/general/url.dart';
import 'package:http/http.dart' as http;

Future cargarDatosUser(String nombre, String apellido, String ci, String numero,
    String telefono, String direccion, String email) async {
  try {
    var url = Uri.parse(GloblaURL().urlGlobal() +
        'cargar_datos_user_edit.php?nombre=$nombre&&apellido=$apellido&&ci=$ci&&numero=$numero&&telefono=$telefono&&direccion=$direccion&&email=$email');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      //print(jsonData);
      return jsonData;
    } else {
      throw Exception("Fallo la Conexión");
    }
  } catch (e) {
    print(e);
    // print("assaasasas");
  }
}
