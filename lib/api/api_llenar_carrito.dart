import 'package:distribuidoraeye/general/url.dart';
import 'package:http/http.dart' as http;

Future llenarCarrito(
    String cantidadUnidad,
    String cantidadCaja,
    String precioUnidad,
    String cliente,
    String inventarioId,
    String idOferta,
    String cuc) async {
  var url = Uri.parse(GloblaURL().urlGlobal() + 'registro_pedido_carrito.php');

  await http.post(url,
      //headers: {"accept": "Application/json"},
      body: {
        'cantidad_unidad': cantidadUnidad,
        'cantidad_caja': cantidadCaja,
        'precio_unidad': precioUnidad,
        'cliente': cliente,
        'inventario_id': inventarioId,
        'id_oferta': idOferta,
        'cuc': cuc
      });

  // var convertadDataJson = jsonDecode(response.body);
  //return convertadDataJson;

  //print(response.body);
}
