import 'package:distribuidoraeye/api/api_facturas.dart';
import 'package:distribuidoraeye/general/url.dart';
import 'package:distribuidoraeye/main.dart';
import 'package:distribuidoraeye/model/despositos.dart';
import 'package:distribuidoraeye/screens/menu/contactos.dart';
import 'package:distribuidoraeye/screens/menu/pedidos_hecho.dart';
import 'package:distribuidoraeye/screens/menu/perfil.dart';
import 'package:distribuidoraeye/screens/principal/home.dart';
import 'package:distribuidoraeye/screens/principal/pagos_cuentas.dart';
import 'package:distribuidoraeye/services/factura.dart';
import 'package:distribuidoraeye/services/imagen_upload.dart';
import 'package:distribuidoraeye/services/notificaciones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProductosAdquiridos extends StatefulWidget {
  final String email;

  ProductosAdquiridos(this.email);

  @override
  _ProductosAdquiridosState createState() => _ProductosAdquiridosState();
}

class _ProductosAdquiridosState extends State<ProductosAdquiridos> {
  final _advancedDrawerController = AdvancedDrawerController();
  final List categoriaList = [
    "Facturas",
    "Realizar Depositos",
  ];

  late bool loadingdeposito;
  List<Deposito> depositoList = [];

  late bool isVisible;
  late bool isVisible1;
  late bool isVisible2;

  late bool isButtomPago;

  var selectedIndex = 0;

  late String numero;
  late String not;
  late String foto;
  late String nombreCompleto;

  @override
  void initState() {
    isVisible = true;
    isVisible1 = false;

    isVisible2 = false;

    numero = '0';
    not = '0';
    foto = '';
    nombreCompleto = '';

    //-----depositos
    isButtomPago = false;
    depositoList = [];
    loadingdeposito = true;
    vista(widget.email);
    //depVista(widget.email);

    _carritoNotifiHecho(widget.email);
    _cargarDatos(widget.email);

    super.initState();
  }

  Widget _buttomPagos() {
    return Visibility(
      visible: isButtomPago,
      child: Container(
          height: 80.0,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Realizar ',
                        style: TextStyle(
                            color: Colors.blueGrey[900],
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Depositos ',
                        style: TextStyle(
                          color: Colors.blueGrey[900],
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: FloatingActionButton(
                  onPressed: () {
                    _navigateAndDisplaySelection(context);
                    /*Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UploadImage(widget.email);
                    }));*/
                  },
                  heroTag: "btn2",
                  splashColor: Colors.blueGrey[900],
                  tooltip: "Tomar o Cargar Una Fotografia",
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 28.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )),
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UploadImage(widget.email)),
    );

    if (result != null) {
      uploadImage(result);
    }
  }

  Future uploadImage(List<dynamic> lista) async {
    final uri = Uri.parse(GloblaURL().urlGlobal() + "upload_imagen.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = lista[0].toString();
    request.fields['asunto'] = lista[1].toString();
    request.fields['cliente'] = lista[2].toString();
    var pic = await http.MultipartFile.fromPath("image", lista[3].path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image Uploded');
      setState(() {
        depVista(lista[2].toString());
        Fluttertoast.showToast(
            backgroundColor: Colors.grey[900],
            textColor: Colors.white,
            msg: "Imagen Cargada",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
      });
    } else {
      print('Image Not Uploded');
    }
  }

  Widget _categorias() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 35.0,
      //color: Colors.black,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoriaList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
                if (index == 0) {
                  isVisible = true;
                  isVisible1 = false;
                  isVisible2 = false;
                  isButtomPago = false;
                }
                if (index == 1) {
                  isVisible = false;
                  isVisible1 = true;
                  isVisible2 = true;
                  isButtomPago = true;
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? Theme.of(context).primaryColor
                      : Colors.grey[400],
                  boxShadow: selectedIndex == index
                      ? [
                          BoxShadow(
                              color: Colors.black,
                              blurRadius: 12.0,
                              spreadRadius: -5.0,
                              offset: Offset(0, 15))
                        ]
                      : null,
                  borderRadius: BorderRadius.circular(20.0)),
              child: Center(
                child: Row(
                  children: [
                    Icon(
                      Icons.double_arrow_rounded,
                      color: selectedIndex == index
                          ? Colors.blueGrey[900]
                          : Colors.grey[400],
                      size: 35.0,
                    ),
                    Text(
                      " " + categoriaList[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedIndex == index
                            ? Colors.white
                            : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
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
              onPressed: () {}),
          SizedBox(
            width: 45.0,
          ),
          IconButton(
              icon: Icon(Icons.view_list_rounded),
              color: Colors.white,
              iconSize: 20.0,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PagosCuentas(widget.email);
                }));
              }),
        ],
      ),
    );
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
                      widget.email,
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
                        username: widget.email,
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
                        email: widget.email,
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
                          widget.email,
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
                      return NotificacionesDis(widget.email);
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
                    showModalErrores(context, widget.email);
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
              return HomePage(username: widget.email);
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
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 70.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Facturas",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 30.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "& Depositos",
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
            _categorias(),
            _buttomPagos(),
            SizedBox(
              height: 15,
            ),
            _facturas(),
            _deposito(),
          ],
        ),
      ),
    );
  }

  Widget _facturas() {
    return Visibility(
      visible: isVisible,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        constraints: BoxConstraints(minHeight: 370, maxHeight: 480),
        child: _listFactura(),
      ),
    );
  }

  _listFactura() {
    final fac = new Factura();
    return FutureBuilder<List>(
        future: fac.cargarFacturas(widget.email),
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            //print(snapshot.data.length);
            if (snapshot.data.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  final pro = snapshot.data[i];
                  int r = i + 1;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FacturaVenta(
                            pro.facturaurl,
                            widget.email,
                            pro.fecha.toString(),
                            pro.factura.toString(),
                            pro.id.toString());
                      }));
                    },
                    child: Container(
                      height: 90.0,
                      padding: EdgeInsets.only(top: 5.0),
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF263238),
                            Color(0xFF26A69A),
                            Color(0xFF263238),
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
                              r.toString(),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 20.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Positioned(
                            top: 45,
                            left: 60,
                            child: Text(
                              pro.factura.toString(),
                              style: TextStyle(
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 60,
                            child: Text(
                              "Factura Nº: ",
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 30,
                            child: Text(
                              "Fecha: \n" + pro.fecha,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  "No Existe Ninguna Factura",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
              );
            }
          } else {
            return Center(
              child: Text(
                "No Existe Ninguna Factura",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0),
                textAlign: TextAlign.center,
              ),
            );
          }
        });
  }

  Widget _deposito() {
    return Visibility(
      visible: isVisible1,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        constraints: BoxConstraints(minHeight: 370, maxHeight: 450),
        child: depositoList.length > 0
            ? _listDeposito()
            : Center(
                child: Text(
                  "No Se Realizo Ninguna Transferencia o Deposito",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }

  _listDeposito() {
    if (loadingdeposito) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: depositoList.length,
        itemBuilder: (context, int index) {
          return GestureDetector(
            onTap: () {
              showDialogFun(
                  context, depositoList[index].foto, depositoList[index].monto);
            },
            child: Container(
              height: 180.0,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
              padding: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                  color: Colors.blueGrey[900],
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFF616161),
                        blurRadius: 50.0,
                        spreadRadius: -30.0,
                        offset: Offset(10, 10))
                  ],
                  borderRadius: BorderRadius.circular(20.0)),
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned(
                    top: -65.0,
                    left: 15,
                    child: FadeInImage.assetNetwork(
                      height: 280,
                      width: 180.0,
                      fadeInCurve: Curves.bounceInOut,
                      fadeOutDuration: Duration(milliseconds: 800),
                      placeholder: 'assets/loading.gif',
                      image: depositoList[index].foto,
                    ),
                  ),
                  Positioned(
                      top: 25.0,
                      left: 220.0,
                      child: Text(
                        'Monto: ' + depositoList[index].monto + " Bs",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      )),
                  Positioned(
                      top: 55.0,
                      left: 220.0,
                      child: Container(
                        width: 150.0,
                        height: 90.0,
                        child: Text(
                          depositoList[index].asunto,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )),
                  Positioned(
                      bottom: 10.0,
                      left: 235.0,
                      child: Text(
                        depositoList[index].fecha,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400]),
                      )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 45.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0))),
                      child: IconButton(
                        onPressed: () {
                          showDialogFunEliminar(
                              context, depositoList[index].id, widget.email);
                        },
                        color: Colors.white,
                        icon: Icon(Icons.delete),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showDialogFunEliminar(BuildContext context, int id, String correo) {
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
                          eliminarDeposito(id.toString(), correo);
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
    );
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
                      fontSize: 25,
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
                        "Monto: " + monto + " Bs",
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

  eliminarDeposito(String id, String user) async {
    try {
      var url1 =
          Uri.parse(GloblaURL().urlGlobal() + 'eliminar_deposito.php?id=' + id);
      await http.get(url1);

      setState(() {
        depVista(user);
      });

      Fluttertoast.showToast(
          backgroundColor: Colors.grey[900],
          textColor: Colors.white,
          msg: "Se Elimino el Deposito",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    } catch (e) {
      print(e);
    }
  }

  vista(String user) {
    setState(() {
      depVista(user);
    });
  }

  depVista(String username) async {
    try {
      var url = Uri.parse(GloblaURL().urlGlobal() +
          'mostrar_depositos.php?cliente=' +
          username);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);

        List<Deposito> depositoListaux = [];

        if (jsonData['Depositos'] == null) {
          setState(() {
            loadingdeposito = false;

            depositoList = [];
          });
        } else {
          for (var item in jsonData['Depositos']) {
            depositoListaux.add(Deposito.fromJson(item));
          }

          setState(() {
            depositoList = depositoListaux;

            loadingdeposito = false;
          });
        }
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      setState(() {
        loadingdeposito = false;

        depositoList = [];
      });
    }
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
}
