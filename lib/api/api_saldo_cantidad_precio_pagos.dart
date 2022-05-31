import 'package:distribuidoraeye/general/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SaldoCantidadPagos {
  Future apiCarritoPrecio(String user, String fecha) async {
    try {
      var url = Uri.parse(GloblaURL().urlGlobal() +
          'saldo_cantidad_fecha_pagos.php?cliente=$user&&fecha=$fecha');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        print(jsonData);

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
