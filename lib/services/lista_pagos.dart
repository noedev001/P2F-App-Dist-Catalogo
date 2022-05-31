import 'dart:convert';

import 'package:distribuidoraeye/api/api_cargar_lista_productos_pagos.dart';
import 'package:distribuidoraeye/api/api_saldo_cantidad_precio_pagos.dart';
import 'package:distribuidoraeye/general/url.dart';
import 'package:distribuidoraeye/model/pagos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListaPagos extends StatefulWidget {
  final String fecha;
  final String user;

  ListaPagos(this.fecha, this.user);

  @override
  _ListaPagosState createState() => _ListaPagosState();
}

class _ListaPagosState extends State<ListaPagos> {
  late bool loading;

  late String fechapago, saldo, precio, pago, cantida;

  late List<PagosList> listPagos;
  @override
  void initState() {
    loading = true;
    listPagos = [];
    fechapago = DateTime.now().toString();
    saldo = '0';
    precio = '0';
    pago = '0';
    cantida = '0';
    _cargarDatos(widget.user, widget.fecha);
    _cargarSaldo(widget.user, widget.fecha);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNav(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.teal[400],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 70.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Lista ",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 30.0,
                        ),
                        //textAlign: TextAlign.center,
                      ),
                      Text(
                        "De Pagos",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30.0),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          _detalle(),
          _listPagos(),
        ],
      ),
    );
  }

  Widget _bottomNav(context) {
    return Container(
      height: 160.0,
      color: Colors.blueGrey[700],
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  " ",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Monto Cancelado $pago Bs ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Saldo Pendiente $saldo Bs ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
          ),
          Container(
            height: 60.0,
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  " Precio Total Pedido: $precio Bs ",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _detalle() {
    return Container(
      height: 80,
      //color: Colors.amber,
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 10.0,
            left: 10,
            child: Text(
              "Fecha de Compra: $fechapago",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          Positioned(
            top: 40.0,
            left: 10,
            child: Text(
              "Articulos: $cantida",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 40,
              width: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF26A69A),
                    Color(0xFF455A64),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0)),
              ),
              child: IconButton(
                onPressed: () {
                  showDialogList(
                    context,
                    widget.user,
                    widget.fecha,
                    saldo,
                  );
                },
                icon: Icon(
                  Icons.view_list,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 60,
            child: Text("Mas..."),
          ),
        ],
      ),
    );
  }

  _listPagos() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return (Expanded(
        child: listPagos.length > 0
            ? Container(
                child: ListView.builder(
                    itemCount: listPagos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 120.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  height: 80.0,
                                  width: 150.0,
                                  decoration: BoxDecoration(
                                      color: listPagos[index].formaPago ==
                                              "Deposito"
                                          ? Theme.of(context).primaryColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(50.0),
                                          bottomRight: Radius.circular(50.0))),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: <Widget>[
                                      Positioned(
                                          left: 10,
                                          top: 10,
                                          child: Text(
                                            listPagos[index].formaPago,
                                            style: TextStyle(
                                                color: listPagos[index]
                                                            .formaPago ==
                                                        "Deposito"
                                                    ? Colors.blueGrey[900]
                                                    : Theme.of(context)
                                                        .primaryColor,
                                                fontWeight: FontWeight.w700),
                                          )),
                                      Positioned(
                                          left: 10,
                                          top: 40,
                                          child: Text(
                                            "Monto: Bs" +
                                                listPagos[index].monto,
                                            style: TextStyle(
                                                color: listPagos[index]
                                                            .formaPago ==
                                                        "Deposito"
                                                    ? Colors.blueGrey[900]
                                                    : Theme.of(context)
                                                        .primaryColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16.0),
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Container(
                                  height: 80.0,
                                  //color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 30.0,
                                      ),
                                      Text(
                                        "Fecha: " + listPagos[index].fechaPago,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.grey[300]),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Center(
                              child: listPagos[index].formaPago == "Deposito"
                                  ? Container(
                                      height: 70.0,
                                      padding: EdgeInsets.only(right: 15.0),
                                      // color: Colors.blueGrey[900],
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              bottomLeft:
                                                  Radius.circular(20.0))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            height: 70.0,
                                            width: 25.0,
                                            child: Center(
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.photo_album,
                                                  size: 30,
                                                ),
                                                color: Colors.white,
                                                splashColor: Colors.white,
                                                onPressed: () {
                                                  showDialogFun(
                                                      context,
                                                      listPagos[index].fotoUrl,
                                                      listPagos[index]
                                                          .fechaDeposito);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : null,
                            )
                          ],
                        ),
                      );
                    }),
              )
            : Container(
                child: Center(child: Text('No existe Ningun Pago Realizado ')),
              )));
  }

  showDialogFun(BuildContext context, String foto, String monto) {
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
              height: 550,
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: FadeInImage.assetNetwork(
                      height: 450,
                      //width: 180.0,
                      fadeInCurve: Curves.bounceInOut,
                      fadeOutDuration: Duration(milliseconds: 800),
                      placeholder: 'assets/loading.gif',
                      image: foto,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Imagen de Deposito",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Fecha: " + monto,
                        maxLines: 3,
                        style: TextStyle(fontSize: 15, color: Colors.grey[500]),
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

  _cargarDatos(String user, String fecha) async {
    try {
      var url = Uri.parse(GloblaURL().urlGlobal() +
          'lista_pagos.php?cliente=$user&&fecha=$fecha');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        // print(jsonData);
        List<PagosList> listaux = [];

        if (jsonData['listapago'] == null) {
          setState(() {
            loading = false;
            listPagos = [];
          });
        } else {
          for (var item in jsonData['listapago']) {
            listaux.add(PagosList.fromJson(item));
          }

          setState(() {
            listPagos = listaux;
            loading = false;
          });
        }
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
        listPagos = [];
      });
    }
  }

  showDialogList(
      BuildContext context, String user, String fecha, String saldo) {
    final lis = new ListProductosPagos();
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
                        "Monto Total: $saldo Bs",
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

  _cargarSaldo(String user, String fecha) async {
    final lisSaldo = new SaldoCantidadPagos();
    var rp = await lisSaldo.apiCarritoPrecio(user, fecha);
    //print(rp);
    setState(() {
      cantida = rp['CantidadProductos'].toString();
      precio = rp['PrecioTotal'].toString();
      saldo = rp['Saldo'].toString();
      pago = rp['Pagos'].toString();
      fechapago = rp['fecha'].toString();
    });
  }
}
