import 'dart:convert';

import 'package:distribuidoraeye/api/api_saldo_total.dart';
import 'package:distribuidoraeye/general/url.dart';
import 'package:distribuidoraeye/main.dart';
import 'package:distribuidoraeye/model/pedido_hecho.dart';
import 'package:distribuidoraeye/screens/menu/contactos.dart';
import 'package:distribuidoraeye/screens/menu/pedidos_hecho.dart';
import 'package:distribuidoraeye/screens/menu/perfil.dart';
import 'package:distribuidoraeye/screens/principal/home.dart';
import 'package:distribuidoraeye/screens/principal/productos_adquiridos.dart';
import 'package:distribuidoraeye/services/lista_pagos.dart';
import 'package:distribuidoraeye/services/notificaciones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PagosCuentas extends StatefulWidget {
  final String user;
  PagosCuentas(this.user);

  @override
  _PagosCuentasState createState() => _PagosCuentasState();
}

class _PagosCuentasState extends State<PagosCuentas> {
  final _advancedDrawerController = AdvancedDrawerController();
  late String saldo;

  late bool loadingdeuda;

  late List<PedidoHechoMet> listDeuda;

  late String numero;
  late String not;
  late String foto;
  late String nombreCompleto;

  @override
  void initState() {
    saldo = '0';
    loadingdeuda = true;
    listDeuda = [];

    numero = '0';
    not = '0';
    foto = '';
    nombreCompleto = '';

    _carritoNotifiHecho(widget.user);
    _cargarDatos(widget.user);

    _datosSaldo(widget.user);
    listVistaSaldo(widget.user);

    super.initState();
  }

  Widget _bottomNav() {
    return Container(
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              icon: Icon(Icons.shop),
              color: Colors.white,
              iconSize: 20.0,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProductosAdquiridos(widget.user);
                }));
              }),
          SizedBox(
            width: 45.0,
          ),
          IconButton(
              icon: Icon(Icons.view_list_rounded),
              color: Colors.white,
              iconSize: 20.0,
              onPressed: () {}),
        ],
      ),
    );
  }

  enviarSugerencias(String datos, String email) async {
    try {
      var url = Uri.parse(GloblaURL().urlGlobal() + 'sugerencias.php');

      final response =
          await http.post(url, body: {'datos': datos, 'email': email});
      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        print(jsonData);
        //return jsonData;
        Fluttertoast.showToast(
            backgroundColor: Colors.grey[900],
            textColor: Colors.white,
            msg: "Sugerencia Enviada",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      print("sugerencias");
      print(e);
    }
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.blueGrey[900],
      controller: _advancedDrawerController,
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(
                    top: 30.0,
                    bottom: 0.0,
                  ),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: foto != ''
                        ? ClipOval(
                            child: FadeInImage.assetNetwork(
                              height: double.infinity,
                              width: double.infinity,
                              fadeInCurve: Curves.bounceInOut,
                              fadeOutDuration: Duration(milliseconds: 800),
                              placeholder: 'assets/loading.gif',
                              image: foto,
                            ),
                          )
                        : ClipOval(
                            child: Image.asset(
                              'assets/lauch.png',
                            ),
                          ),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3.0,
                    ),
                  ),
                ),
                ListTile(
                    title: Text(
                      widget.user,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    subtitle: nombreCompleto != ''
                        ? Text(
                            nombreCompleto,
                            style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          )
                        : Text(
                            'Cargando....',
                            style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          )),
                Divider(),
                ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return HomePage(
                        username: widget.user,
                      );
                    }));
                  },
                  leading: Icon(
                    Icons.home,
                  ),
                  title: Text('Inicio'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PerfilCliente(
                        email: widget.user,
                      );
                    }));
                  },
                  leading: Icon(Icons.account_circle_rounded),
                  title: Text('Perfil'),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    if (int.parse(not) >= 1) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PedidoHecho(
                          widget.user,
                        );
                      }));
                    } else {
                      Fluttertoast.showToast(
                          backgroundColor: Colors.grey[900],
                          textColor: Colors.white,
                          msg: "No Hay Ningun Pedido en Espera",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM);
                    }
                  },
                  leading: Icon(
                    Icons.info_rounded,
                  ),
                  title: Text('Pedidos Informacion'),
                  trailing: Icon(
                    Icons.notification_important,
                    color: int.parse(not) >= 1
                        ? Colors.redAccent
                        : Colors.transparent,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return NotificacionesDis(widget.user);
                    }));
                  },
                  leading: Icon(Icons.notifications_outlined),
                  title: Text('Notificaciones'),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ContactosDis();
                    }));
                  },
                  leading: Icon(Icons.phone),
                  title: Text('Contactos'),
                ),
                ListTile(
                  onTap: () {
                    showModalErrores(context, widget.user);
                  },
                  leading: Icon(Icons.help),
                  title: Text('Ayuda'),
                  subtitle: Text(
                    'Informanos de Errores y Ayudanos a Mejorar',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('Exit'),
                  leading: Icon(Icons.exit_to_app),
                  onTap: () async {
                    GoogleSignIn _googleSignIn = GoogleSignIn();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    if (prefs.getString('login') == '0') {
                      await _googleSignIn.signOut();
                    }

                    if (prefs.getString('login') == '1') {
                      print('entramos a salir de face');
                      await FacebookAuth.instance.logOut();
                      await FacebookAuth.i.logOut();

                      //await Face
                    }

                    prefs.clear();

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                      return MyApp();
                    }), (route) => false);
                  },
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: Text('Bienvenidos a la Distribuidora E&E'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[400],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomePage(username: widget.user);
            }));
          },
          heroTag: "btn1",
          child: Icon(
            Icons.home,
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          shape: CircularNotchedRectangle(),
          child: _bottomNav(),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: _handleMenuButtonPressed,
                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: _advancedDrawerController,
                  builder: (context, value, child) {
                    return Icon(
                      value.visible == true ? Icons.clear : Icons.sort,
                    );
                  },
                ),
              ),
            ],
          ),
          elevation: 0,
        ),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Cuentas",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 30.0,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          "& Saldos",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            _saldo(),
            SizedBox(
              height: 30.0,
            ),
            _pagos(),
          ],
        ),
      ),
    );
  }

  _saldo() {
    return Container(
      height: 80.0,
      //color: Colors.black,
      child: Stack(
        children: [
          Positioned(
            left: 20.0,
            child: Text(
              "LISTA DE PAGOS",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 25.0,
              ),
            ),
          ),
          Positioned(
            top: 50.0,
            right: 10,
            child: Text(
              "Saldo Total: $saldo Bs",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25.0),
            ),
          ),
        ],
      ),
    );
  }

  _pagos() {
    return Container(
      //height: 370.0,
      //color: Colors.amber,
      constraints: BoxConstraints(minHeight: 370, maxHeight: 460),
      child: listDeuda.length > 0
          ? _listaDeuda()
          : Center(
              child: Text(
                "Uste no tiene Saldo Pendiente",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  _listaDeuda() {
    if (loadingdeuda) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: listDeuda.length,
      itemBuilder: (context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ListaPagos(listDeuda[index].fecha, widget.user);
            }));
          },
          child: Stack(
            children: [
              Container(
                height: 180.0,
                width: 40,
                padding: EdgeInsets.only(top: 50.0, left: 10, right: 10),
                margin: EdgeInsets.only(
                    top: 20.0, bottom: 10.0, left: 0.0, right: 8.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF263238),
                      Color(0xFF26A69A),
                      Color(0xFF263238),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                ),
                child: Text(
                  "********",
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                height: 180.0,
                padding: EdgeInsets.only(top: 5.0),
                margin: EdgeInsets.only(
                    top: 20.0, bottom: 10.0, left: 80.0, right: 8.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFEEEEEE),
                      Color(0xFFE0E0E0),
                      Color(0xFFBDBDBD),
                      Color(0xFF757575),
                      Color(0xFF424242),
                      Color(0xFF212121),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 30,
                      left: 20,
                      child: Text(
                        "LISTA DE COMPRA",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Positioned(
                      top: 65,
                      left: 20,
                      child: Text(
                        "Cantidad de Productos: " +
                            listDeuda[index].cantidadProductos,
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 20,
                      child: Text(
                        "Pecio Total: " + listDeuda[index].precioTotal + ' Bs',
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Positioned(
                      top: 135,
                      left: 20,
                      child: Text(
                        "Fecha: " + listDeuda[index].fecha,
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 50,
                        width: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF26A68A),
                              Color(0xFF455A64),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                        ),
                        child: Icon(Icons.contacts_outlined),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  listVistaSaldo(String username) async {
    try {
      var url = Uri.parse(
          GloblaURL().urlGlobal() + 'mostrar_saldos.php?cliente=' + username);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);

        List<PedidoHechoMet> listaux = [];

        if (jsonData == null) {
          setState(() {
            loadingdeuda = false;
            listDeuda = [];
          });
        } else {
          for (var item in jsonData) {
            listaux.add(PedidoHechoMet.fromJson(item));
          }

          setState(() {
            listDeuda = listaux;
            loadingdeuda = false;
          });
        }
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      setState(() {
        loadingdeuda = false;
        listDeuda = [];
      });
    }
  }

  _datosSaldo(String user) async {
    final lisSal = new SaldoTotal();
    var rp = await lisSal.apisaldoTotal(user);
    setState(() {
      saldo = rp[0]['saldo'].toString();
    });
  }

  _carritoNotifiHecho(String cliente) async {
    try {
      var url = Uri.parse(GloblaURL().urlGlobal() +
          'notificaciones_pedido _hecho.php?cliente=' +
          cliente);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        //print(jsonData);
        String aux = jsonData['Cantidad'][0]['Notificacion'].toString();
        setState(() {
          not = aux;
        });
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      print("noti");
      print(e);
      not = '0';
    }
  }

  _cargarDatos(String cliente) async {
    try {
      var url = Uri.parse(
          GloblaURL().urlGlobal() + 'cargar_datos_user.php?cliente=' + cliente);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        String aux = jsonData['Datos'][0]['cli_nombres'].toString() +
            ' ' +
            jsonData['Datos'][0]['cli_apellidos'].toString();
        String aux1 = jsonData['Datos'][0]['foto'].toString();
        print(aux1);
        print('aki');
        setState(() {
          nombreCompleto = aux;
          foto = aux1;
        });
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      print('Cargar DAtos');
      nombreCompleto = '';
      foto = '';
      print(e);
    }
  }

  showModalErrores(BuildContext context, String user) {
    final _formKey = GlobalKey<FormState>();
    final errorController = TextEditingController();
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
              height: 180,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Stack(
                //crossAxisAlignment: CrossAxisAlignment.center,
                clipBehavior: Clip.none,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: errorController,
                        decoration: InputDecoration(
                            labelText: 'Sugerencias',
                            hintText: "Ej: Sugerencias...",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Llene este campo";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 15.0,
                      left: 20,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            //_eliminarArticuloCarrito(id.toString(), user);
                            var dato = errorController.text;

                            enviarSugerencias(dato, user);
                            Navigator.of(context).pop(true);
                          }
                        },
                        splashColor: Colors.blueGrey[900],
                        child: Container(
                          child: Row(
                            children: [Icon(Icons.done), Text(" Enviar")],
                          ),
                        ),
                      )),
                  Positioned(
                      bottom: 15.0,
                      right: 20,
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
                              Text("Ahora No "),
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
    );
  }
}
