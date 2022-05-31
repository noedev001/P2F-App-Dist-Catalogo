import 'dart:convert';
import 'package:distribuidoraeye/general/url.dart';
import 'package:distribuidoraeye/model/productos_carrito.dart';
import 'package:http/http.dart' as http;

class ListPedidoHecho {
  Future<List> cargaPedido(String user, String fecha) async {
    try {
      var url = Uri.parse(GloblaURL().urlGlobal() +
          'lista_pedido_hecho.php?cliente=$user&&fecha=$fecha');

      final resp = await http.get(url);

      var jsonData = jsonDecode(resp.body);
      //print(jsonData);
      List<ProductCarrito> pedidoList = [];

      //print(jsonData);
      for (var item in jsonData['listapedido']) {
        pedidoList.add(ProductCarrito.fromJson(item));
      }

      return pedidoList;
    } catch (e) {
      print(e);
      List<ProductCarrito> pedidoList = [];
      return pedidoList;
    }
  }
}
