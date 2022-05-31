import 'package:carousel_slider/carousel_slider.dart';
import 'package:distribuidoraeye/api/api_llenar_carrito.dart';
import 'package:distribuidoraeye/general/url.dart';
import 'package:distribuidoraeye/model/imagen_carrusel.dart';
import 'package:distribuidoraeye/model/productos.dart';
import 'package:distribuidoraeye/screens/carrito/tienda_carrito.dart';
import 'package:distribuidoraeye/screens/principal/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:switcher/core/switcher_size.dart';
import 'dart:convert';

import 'package:switcher/switcher.dart';

class ProductoDetalle extends StatefulWidget {
  final Product product;
  final String username;

  ProductoDetalle(this.username, this.product);

  @override
  _ProductoDetalleState createState() => _ProductoDetalleState();
}

class _ProductoDetalleState extends State<ProductoDetalle> {
  final List selectList = ["Unidad", "Cajas"];

  int aux = 0;

  late int photoIndex;

  late String numero;

  bool isVisible = false;

  int des = 0;

  late List<ImagenCarrusel> listImagen;

  @override
  void initState() {
    super.initState();
    if (widget.product.nota == "Venta por Caja o Unidad") {
      isVisible = true;
    }
    numero = '0';
    photoIndex = 0;
    listImagen = [];
    _carritoNotifi(widget.username);

    _imageCarrusel(widget.product.idproducto);
  }

  void aumentar() {
    setState(() {
      aux++;
    });
  }

  void disminuir() {
    setState(() {
      if (aux > 0) {
        aux--;
      }
    });
  }

  Widget _bootomEle() {
    return Visibility(
      visible: isVisible,
      child: Container(
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Caja",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 8,
            ),
            Switcher(
              value: true,
              size: SwitcherSize.large,
              switcherButtonRadius: 50,
              enabledSwitcherButtonRotate: true,
              colorOn: Theme.of(context).primaryColor,
              colorOff: Color(0xFF757575),
              iconOn: Icons.assignment_turned_in_rounded,
              iconOff: Icons.table_chart,
              onChanged: (bool position) {
                if (position) {
                  if (widget.product.nota == "Venta por Caja o Unidad") {
                    des = 1;
                  }
                } else {
                  if (widget.product.nota == "Venta por Caja o Unidad") {
                    des = 2;
                  }
                }
              },
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "Unidad",
              style: TextStyle(color: Colors.white),
            ),
          ],
        )),
      ),
    );
  }

  Widget _bottomNav(context) {
    return Container(
      height: 120.0,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Cantidad",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 135.0,
                  //height: 80.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            color: Color(0XFF9F9F9F),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              disminuir();
                            },
                            splashColor: Colors.cyan,
                            icon: Icon(
                              Icons.remove,
                            ),
                            iconSize: 25,
                          ),
                        ),
                      ),
                      Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            color: Color(0XFF9F9F9F),
                            borderRadius: BorderRadius.circular(25.0)),
                        child: Center(
                          child: Text(
                            "$aux",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ),
                      ),
                      Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            color: Color(0XFF9F9F9F),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              aumentar();
                            },
                            splashColor: Colors.cyan,
                            icon: Icon(
                              Icons.add,
                            ),
                            iconSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (aux > 0) {
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
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                              ),
                              Positioned(
                                top: -50.0,
                                left: 85.0,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(
                                    "assets/3.gif",
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 80.0,
                                left: 50,
                                child: Text(
                                  " Agregar al Carrito?",
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
                                      if (aux > 0) {
                                        agregarCarrito();
                                        Navigator.of(context).pop();
                                      } else {
                                        Navigator.of(context).pop();
                                        Fluttertoast.showToast(
                                            backgroundColor: Colors.grey[900],
                                            textColor: Colors.white,
                                            msg:
                                                "Agregar Cantidad de Articulos",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP);
                                      }
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
              } else {
                Fluttertoast.showToast(
                    backgroundColor: Colors.grey[900],
                    textColor: Colors.white,
                    msg: "La cantidad de Productos tiene que se mayor",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM);
              }
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
                  Text(
                    " Agregar a mi carrito",
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
      title: "Detalles de Articulo",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Theme.of(context).primaryColor),
      home: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _bottomNav(context),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                return HomePage(
                  username: widget.username,
                );
              }), (route) => false);
            },
          ),
          actions: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                      size: 35.0,
                    ),
                    onPressed: () {
                      if (int.parse(numero) >= 1) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CartScreen(email: widget.username);
                        }));
                      } else {
                        Fluttertoast.showToast(
                            backgroundColor: Colors.grey[900],
                            textColor: Colors.white,
                            msg: "Debe Agregar Aticulos al Carrito",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM);
                      }
                    }),
                Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: Container(
                    child: Text(
                      numero,
                      style: TextStyle(
                          color: int.parse(numero) >= 1
                              ? Colors.white
                              : Colors.transparent,
                          fontWeight: FontWeight.normal,
                          fontSize: 12.0),
                    ),
                    alignment: Alignment.center,
                    width: 15.0,
                    height: 15.0,
                    decoration: BoxDecoration(
                        color: int.parse(numero) >= 1
                            ? Colors.redAccent
                            : Colors.transparent,
                        shape: BoxShape.circle),
                  ),
                ),
              ],
            )
          ],
          elevation: 0,
        ),
        body: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 0.0),
                height: 300.0,
                color: Colors.white,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 300.0,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    initialPage: 0,
                  ),
                  items: listImagen.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: FadeInImage.assetNetwork(
                            fadeInCurve: Curves.bounceInOut,
                            fadeOutDuration: Duration(milliseconds: 800),
                            placeholder: 'assets/loading.gif',
                            image: i.avatarurl,
                            height: 100,
                            width: 300.0,
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    );
                  }).toList(),
                )),
            ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: widget.product.nota == "Venta por Caja o Unidad"
                      ? MediaQuery.of(context).size.height - 460.0
                      : MediaQuery.of(context).size.height - 500.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blueGrey[900],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0))),
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Positioned(
                      top: -80,
                      right: -5.0,
                      child: Container(
                        height: 80.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFF424242),
                                  blurRadius: 15.0,
                                  spreadRadius: -12,
                                  offset: Offset(0, 15))
                            ]),
                        child: Center(
                          child: Text(
                            "Bs" + widget.product.precio,
                            style: TextStyle(
                              fontSize: 21.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.product.nombre + " - " + widget.product.marca,
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[400]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: 20.0,
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 5.0),
                                  Text(
                                    widget.product.modelo +
                                        " - " +
                                        widget.product.medida,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: Color(0XFF9F9F9F)),
                                  )
                                ],
                              ),
                            ),
                            Text(
                              widget.product.nota,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            "Categorias : " + widget.product.categoria,
                            style: TextStyle(
                                fontSize: 15.0,
                                height: 1.5,
                                color: Colors.grey[400]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 0.0,
                          ),
                          child: Text(
                            "Unidades por Caja : " +
                                widget.product.cantidadUnidad,
                            style: TextStyle(
                                fontSize: 15.0,
                                height: 1.5,
                                color: Colors.grey[400]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Text(
                            "Precio de Venta por Unidad ",
                            style: TextStyle(
                              fontSize: 15.0,
                              height: 1.5,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            widget.product.descripcion,
                            style: TextStyle(
                                fontSize: 15.0,
                                height: 1.5,
                                color: Colors.grey[400]),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _bootomEle(),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> agregarCarrito() async {
    int unidad = 0;
    int caja = 0;
    if (des == 0) {
      if (widget.product.nota == "Venta unicamente por Unidad") {
        unidad = aux;
        caja = 0;
      }
      if (widget.product.nota == "Venta unicamente por Caja") {
        unidad = 0;
        caja = aux;
      }
    }

    if (des == 1) {
      unidad = aux;
      caja = 0;
    }

    if (des == 2) {
      unidad = 0;
      caja = aux;
    }

    if (widget.product.nota == "Venta por Caja o Unidad") {}
    llenarCarrito(
        unidad.toString(),
        caja.toString(),
        widget.product.precio,
        widget.username,
        widget.product.id.toString(),
        '0',
        widget.product.cantidadUnidad);

    //carritoProductos(widget.usermane);
    //
    setState(() {
      int sum = int.parse(numero) + 1;
      numero = sum.toString();
    });

    Fluttertoast.showToast(
        backgroundColor: Colors.grey[900],
        textColor: Colors.white,
        msg: "Se Agrego al Carrito",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  _carritoNotifi(String cliente) async {
    try {
      var url = Uri.parse(GloblaURL().urlGlobal() +
          'notificaciones_carrito.php?cliente=' +
          cliente);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        String aux = jsonData['Cantidad'][0]['Notificacion'].toString();
        setState(() {
          numero = aux;
        });
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      numero = '0';
    }
  }

  _imageCarrusel(String id) async {
    try {
      var url = Uri.parse(
          GloblaURL().urlGlobal() + 'carrusel_imagenes.php?id_producto=$id');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        List<ImagenCarrusel> listaux = [];
        //print(jsonData.toString());
        for (var item in jsonData) {
          listaux.add(ImagenCarrusel.fromJson(item));
        }

        setState(() {
          listImagen = listaux;
        });
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      print(e);
      List<ImagenCarrusel> listaux = [];
      return listaux;
    }
  }
}
