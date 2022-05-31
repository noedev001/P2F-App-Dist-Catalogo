import 'dart:convert';
import 'package:distribuidoraeye/general/url.dart';
import 'package:distribuidoraeye/model/productos_carrito.dart';
import 'package:http/http.dart' as http;

class ListProductosPagos {
  Future<List> cargaPedido(String user, String fecha) async {
    try {
      print(user);
      print(fecha);
      var url = Uri.parse(GloblaURL().urlGlobal() +
          'lista_productos_pagos.php?cliente=$user&&fecha=$fecha');

      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        String body = utf8.decode(resp.bodyBytes);
        final jsonData = jsonDecode(body);
        List<ProductCarrito> pedidoList = [];

        print(jsonData);
        for (var item in jsonData['listapedido']) {
          pedidoList.add(ProductCarrito.fromJson(item));
        }
        return pedidoList;
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      print(e);
      print("asdasd");
      List<ProductCarrito> pedidoList = [];
      return pedidoList;
    }
  }
}
