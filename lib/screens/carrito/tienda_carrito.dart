import 'package:distribuidoraeye/api/api_cantidad_precio_carrito.dart';
import 'package:distribuidoraeye/api/api_pedido_realizado.dart';
import 'package:distribuidoraeye/general/url.dart';
import 'package:distribuidoraeye/model/productos_carrito.dart';
import 'package:distribuidoraeye/screens/principal/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartScreen extends StatefulWidget {
  final String email;
  CartScreen({required this.email});
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late bool loading;
  late List<ProductCarrito> productsListCarrito;

  late String can;
  late String pre;

  late bool isVisible;
  int des = 0;

  int aux = 0;

  @override
  void initState() {
    productsListCarrito = [];
    loading = true;
    can = '0';
    pre = '0';
    isVisible = true;

    carritoProductos(widget.email);
    _cargarCantPrecio(widget.email);
    super.initState();
  }

  void aumentar() {
    setState(() {
      aux++;
      print(aux);
    });
  }

  void disminuir() {
    setState(() {
      if (aux > 0) {
        aux--;
      }
    });
  }

  Widget _products() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return (Expanded(
      child: Container(
        child: ListView.builder(
            itemCount: productsListCarrito.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 150.0,
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
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(50.0),
                                  bottomRight: Radius.circular(50.0))),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Positioned(
                                right: -5,
                                top: -25,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.blueGrey[900],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: -20,
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: FadeInImage.assetNetwork(
                                      height: 250.0,
                                      width: 250.0,
                                      fadeInCurve: Curves.bounceInOut,
                                      fadeOutDuration:
                                          Duration(milliseconds: 800),
                                      placeholder: 'assets/loading.gif',
                                      image: productsListCarrito[index].imagen,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Container(
                          height: 85.0,
                          //color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                //color: Colors.amber,
                                width: 200.0,
                                child: Text(
                                  productsListCarrito[index].nombre +
                                      " - " +
                                      productsListCarrito[index].marca,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.grey[800]),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "Bs " + productsListCarrito[index].preciototal,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w900),
                              ),
                              Text(
                                int.parse(productsListCarrito[index]
                                            .cantidadcaja) >
                                        0
                                    ? "Cantidad de Cajas : " +
                                        productsListCarrito[index].cantidadcaja
                                    : "Cantidad Unidades: " +
                                        productsListCarrito[index]
                                            .cantidadunidad,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[800]),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 70.0,
                      padding: EdgeInsets.only(right: 15.0),
                      // color: Colors.blueGrey[900],
                      decoration: BoxDecoration(
                          color: Colors.blueGrey[900],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 70.0,
                            width: 18.0,
                            child: Center(
                              child: IconButton(
                                icon: Icon(Icons.delete),
                                color: Theme.of(context).primaryColor,
                                splashColor: Colors.white,
                                onPressed: () {
                                  _showDialogEliminarArticulo(
                                      context,
                                      productsListCarrito[index].id,
                                      widget.email);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    ));
  }

  Widget _bottomNav(context) {
    return Container(
      height: 110.0,
      color: Colors.blueGrey[900],
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  can + " Articulos",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Precio Total Bs " + pre,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Center(
                    child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueGrey[900],
                        ),
                        padding: EdgeInsets.all(5),
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            Positioned(
                              top: -55.0,
                              left: 80.0,
                              child: CircleAvatar(
                                radius: 65,
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            ),
                            Positioned(
                              top: -50.0,
                              left: 85.0,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                  "assets/Imagen-animada.gif",
                                ),
                              ),
                            ),
                            Positioned(
                              top: 80.0,
                              left: 50,
                              child: Text(
                                " Realizar Pedido?",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 20.0,
                                left: 40,
                                // ignore: deprecated_member_use
                                child: FlatButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    realizarPedidoHecho(widget.email);
                                    setState(() {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return HomePage(
                                          username: widget.email,
                                        );
                                      }));
                                    });
                                  },
                                  splashColor: Colors.blueGrey[900],
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Icon(Icons.done),
                                        Text(" Si!!")
                                      ],
                                    ),
                                  ),
                                )),
                            Positioned(
                                bottom: 20.0,
                                right: 40,
                                // ignore: deprecated_member_use
                                child: FlatButton(
                                  color: Colors.red,
                                  splashColor: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Text(" No "),
                                        Icon(Icons.cancel_outlined),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ).then((value) {
                // ProductosAdquiridos().createState().removeChecked(correo);
                print("Entre Al metodo  Dialog");
              });
            },
            child: Container(
              height: 60.0,
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  Text(
                    " Realizar Pedido",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Theme.of(context).primaryColor),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[400],
        bottomNavigationBar: _bottomNav(context),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                return HomePage(
                  username: widget.email,
                );
              }), (route) => false);
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
                          "Carrito ",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 30.0),
                        ),
                        Text(
                          "De Compras",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30.0),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            _products()
          ],
        ),
      ),
    );
  }

  _showDialogEliminarArticulo(BuildContext context, String id, String user) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey[900],
              ),
              padding: EdgeInsets.all(5),
              height: 200,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Stack(
                //crossAxisAlignment: CrossAxisAlignment.center,
                clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned(
                    top: -55.0,
                    left: 80.0,
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Positioned(
                    top: -50.0,
                    left: 85.0,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                        "assets/delete.gif",
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80.0,
                    left: 50,
                    child: Text(
                      "Decea Eliminar?",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 20.0,
                      left: 40,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          _eliminarArticuloCarrito(id.toString(), user);

                          Navigator.of(context).pop(true);
                        },
                        splashColor: Colors.blueGrey[900],
                        child: Container(
                          child: Row(
                            children: [Icon(Icons.done), Text(" Si!!")],
                          ),
                        ),
                      )),
                  Positioned(
                      bottom: 20.0,
                      right: 40,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        color: Colors.red,
                        splashColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Container(
                          child: Row(
                            children: [
                              Text(" No "),
                              Icon(Icons.cancel_outlined),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) {
      //ProductosAdquiridos().createState().removeChecked(correo);
      print("Entre Al metodo eliminar Dialog");
    });
  }

  Future carritoProductos(String username) async {
    try {
      var url = Uri.parse(GloblaURL().urlGlobal() +
          'mostrar_carrito_pedido_espera.php?cliente=' +
          username);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        print(jsonData);
        List<ProductCarrito> productsListCarrito1 = [];
        for (var item in jsonData['PedidoEspera']) {
          productsListCarrito1.add(ProductCarrito.fromJson(item));
        }

        setState(() {
          productsListCarrito = productsListCarrito1;
          loading = false;
        });
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      print(e);
      loading = false;
    }
  }

  _cargarCantPrecio(String user) async {
    final lisCant = new CarritoPrecioCantidad();

    var rp = await lisCant.apiCarritoPrecio(user);
    //print(rp);
    setState(() {
      can = rp[0]['CantidadProductos'].toString();
      pre = rp[0]['PrecioTotal'].toString();
    });
  }

  _eliminarArticuloCarrito(String id, String user) async {
    try {
      var url = Uri.parse(GloblaURL().urlGlobal() +
          'eliminar_articulo_carrrito.php?id_pedido=' +
          id);
      await http.get(url);

      setState(() {
        _cargarCantPrecio(user);
        carritoProductos(user);
      });
      Fluttertoast.showToast(
          backgroundColor: Colors.grey[900],
          textColor: Colors.white,
          msg: "Se Elimino el Articulo",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          backgroundColor: Colors.grey[900],
          textColor: Colors.white,
          msg: "No se pudo Eliminar Articulo",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    }
  }
}
