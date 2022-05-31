import 'package:distribuidoraeye/general/url.dart';
import 'package:distribuidoraeye/model/productos.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future generalProductos() async {
  try {
    var url = Uri.parse(GloblaURL().urlGlobal() + 'producto_general.php');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      return jsonData;
    } else {
      throw Exception("Fallo la Conexión");
    }
  } catch (e) {
    print("Error Generarllll");
    List<Product> lisaux = [];
    return lisaux;
  }
}
