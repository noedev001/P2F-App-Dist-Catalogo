import 'package:distribuidoraeye/general/url.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

realizarPedidoHecho(String user) async {
  try {
    var url = Uri.parse(
        GloblaURL().urlGlobal() + 'realizar_pedido.php?cliente=' + user);
    await http.get(url);

    Fluttertoast.showToast(
        backgroundColor: Colors.grey[900],
        textColor: Colors.white,
        msg: "Pedido Solicitado",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  } catch (e) {
    print("Error Al Eliminar");
  }
}
