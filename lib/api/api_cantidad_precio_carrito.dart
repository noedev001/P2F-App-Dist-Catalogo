import 'package:distribuidoraeye/general/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarritoPrecioCantidad {
  Future apiCarritoPrecio(String user) async {
    try {
      var url = Uri.parse(GloblaURL().urlGlobal() +
          'cantidad_precio_carrito.php?cliente=' +
          user);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        return jsonData;
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
