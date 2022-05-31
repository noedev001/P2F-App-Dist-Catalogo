import 'dart:convert';

import 'package:distribuidoraeye/api/api_cargar_pedido_hecho.dart';
import 'package:distribuidoraeye/general/url.dart';
import 'package:distribuidoraeye/model/pedido_hecho.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class PedidoHecho extends StatefulWidget {
  final String email;
  PedidoHecho(this.email);
  @override
  _PedidoHechoState createState() => _PedidoHechoState();
}

class _PedidoHechoState extends State<PedidoHecho> {
  late bool loading;

  late List<PedidoHechoMet> listPedidoHecho;

  @override
  void initState() {
    loading = true;
    listPedidoHecho = [];

    _cargarPedidos(widget.email);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(top: 150.0),
            child: Center(
              child: Text(
                "Pedido Hechos",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 20.0),
              ),
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
          Container(
            alignment: Alignment.center,
            width: 50.0,
            //color: Colors.white,
            child: Center(
              child: Text(
                "Todo los Productos estan a la Espera de ser entregados",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          _pedidosRealizados()
        ],
      ),
    );
  }

  Widget _pedidosRealizados() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return (Expanded(
      child: Container(
        width: 260.0,
        child: ListView.builder(
            itemCount: listPedidoHecho.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 260.0,
                // color: Colors.black,
                padding: EdgeInsets.only(top: 20.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 30.0,
                      child: Container(
                        height: 200.0,
                        width: 350.0,
                        //padding: EdgeInsets.only(right: 15.0),
                        // color: Colors.blueGrey[900],
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[900],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(90.0),
                            bottomRight: Radius.circular(90.0),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80.0,
                      child: Text(
                        "Pedido Por Entregar",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0),
                      ),
                    ),
                    Positioned(
                      top: 120.0,
                      child: Text(
                        "Cantidad De Productos: " +
                            listPedidoHecho[index].cantidadProductos,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0),
                      ),
                    ),
                    Positioned(
                      top: 150.0,
                      child: Text(
                        "Fecha de Pedido: " + listPedidoHecho[index].fecha,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0),
                      ),
                    ),
                    Positioned(
                      top: 175.0,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        onPressed: () {
                          showDialogList(
                              context,
                              widget.email,
                              listPedidoHecho[index].fecha,
                              listPedidoHecho[index].precioTotal);
                        },
                        color: Theme.of(context).primaryColor,
                        hoverColor: Colors.white,
                        child: Icon(Icons.list),
                      ),
                    ),
                    Positioned(
                      top: -20.0,
                      //mainAxisAlignment: MainAxisAlignment.end,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/carrito_sams.gif'),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 4.0,
                          ),
                        ),
                        margin: EdgeInsets.only(bottom: 5.0),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    ));
  }

  showDialogList(
      BuildContext context, String user, String fecha, String precio) {
    final lis = new ListPedidoHecho();
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(5),
              height: 500,
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Lista del Pedido",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.blueGrey[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Divider(
                    color: Colors.black,
                    height: 5,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 370,
                    //color: Colors.amber,
                    child: FutureBuilder<List>(
                        future: lis.cargaPedido(user, fecha),
                        builder: (_, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            //print(snapshot.data.length);
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              // ignore: missing_return
                              itemBuilder: (context, i) {
                                final pro = snapshot.data[i];
                                int r = i + 1;
                                return ListTile(
                                  leading: Text(
                                    (r).toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  title: Text(
                                    pro.nombre + " - " + pro.marca,
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.w800),
                                  ),
                                  subtitle: int.parse(pro.cantidadcaja) > 0
                                      ? Text(
                                          "Cantidad Caja: " + pro.cantidadcaja,
                                          style: TextStyle(
                                              color: Colors.grey[900],
                                              fontSize: 12.0),
                                        )
                                      : Text(
                                          "Cantidad Unidad: " +
                                              pro.cantidadunidad,
                                          style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 12.0),
                                        ),
                                  trailing: Text(
                                    pro.preciototal + " Bs",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w800),
                                  ),
                                );
                              },
                            );
                          } else {
                            // Loading
                            return Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 4));
                          }
                        }),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Align(
                      child: Text(
                        "Monto Total: " + precio + " Bs",
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _cargarPedidos(String user) async {
    try {
      var url =
          Uri.parse(GloblaURL().urlGlobal() + 'pedido_hecho.php?cliente=$user');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);

        List<PedidoHechoMet> listaux = [];
        // print(jsonData);
        for (var item in jsonData) {
          listaux.add(PedidoHechoMet.fromJson(item));
        }

        setState(() {
          listPedidoHecho = listaux;
          loading = false;
        });
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      print(e);
      //print("aki");
      loading = false;
    }
  }
}
