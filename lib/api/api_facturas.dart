import 'dart:convert';
import 'package:distribuidoraeye/general/url.dart';
import 'package:distribuidoraeye/model/facturas.dart';
import 'package:http/http.dart' as http;

class Factura {
  Future<List> cargarFacturas(String user) async {
    try {
      var url = Uri.parse(
          GloblaURL().urlGlobal() + 'mostrar_facturas.php?cliente=$user');

      final resp = await http.get(url);

      var jsonData = jsonDecode(resp.body);
      //print(jsonData);
      List<FacturaList> facturaList = [];

      if (jsonData['Facturas'] == null) {
        List<FacturaList> facturaList = [];
        //print(facturaList);
        return facturaList;
      } else {
        //print(jsonData);

        for (var item in jsonData['Facturas']) {
          facturaList.add(FacturaList.fromJson(item));
        }
        //print(facturaList.length);
        return facturaList;
      }
    } catch (e) {
      print(e);
      List<FacturaList> facturaList = [];
      // print(facturaList);
      return facturaList;
    }
  }
}
