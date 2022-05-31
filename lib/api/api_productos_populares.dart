import 'package:distribuidoraeye/general/url.dart';
import 'package:distribuidoraeye/model/productos.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future popularesProductos(String username) async {
  try {
    var url = Uri.parse(
        GloblaURL().urlGlobal() + 'productos_para_ti.php?cliente=' + username);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      return jsonData;
    } else {
      throw Exception("Fallo la Conexión");
    }
  } catch (e) {
    print("Error Para tiii");
    List<Product> lisaux = [];
    return lisaux;
  }
}
