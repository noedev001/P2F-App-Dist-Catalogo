import 'package:distribuidoraeye/general/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Cuotas {
  Future apicuotaevents(String user) async {
    try {
      var url = Uri.parse(
          GloblaURL().urlGlobal() + 'fecha_cuota.php?cliente=' + user);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);

        if (jsonData == null) {
          return [];
        } else {
          return jsonData;
        }
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
