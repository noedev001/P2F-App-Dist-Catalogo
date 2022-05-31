import 'dart:convert';
import 'package:distribuidoraeye/general/url.dart';
import 'package:distribuidoraeye/model/productos.dart';
import 'package:http/http.dart' as http;

class ProductService {
  Future<List> getCountryByName(String name) async {
    try {
      var url = Uri.parse(
          GloblaURL().urlGlobal() + 'buscar_producto.php?nombre=' + name);

      final resp = await http.get(url);

      var jsonData = jsonDecode(resp.body);

      List<Product> busquedaList = [];

      //print(jsonData);
      for (var item in jsonData) {
        busquedaList.add(Product.fromJson(item));
      }

      return busquedaList;
    } catch (e) {
      print(e);
      List<Product> busquedaList = [];
      return busquedaList;
    }
  }
}
