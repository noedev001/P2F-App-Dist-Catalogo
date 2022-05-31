import 'dart:convert';
import 'dart:io';
import 'package:android_external_storage/android_external_storage.dart';
import 'package:dio/dio.dart';
import 'package:distribuidoraeye/general/url.dart';
import 'package:distribuidoraeye/model/productos_factura.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class FacturaVenta extends StatefulWidget {
  final String facturaurl, email, fecha, factura, id;
  FacturaVenta(this.facturaurl, this.email, this.fecha, this.factura, this.id);
  @override
  _FacturaVentaState createState() => _FacturaVentaState();
}

class _FacturaVentaState extends State<FacturaVenta> {
  late String nombre, apellido, ci, numero, precio;
  late List<ProductosFactura> productsListFactura;

  late String path;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    //loadDocument();
    nombre = '';
    apellido = '';
    ci = '';
    numero = '';
    precio = '';

    cargarDatos(widget.email);
    cargarDatosProductos(widget.id);
    productsListFactura = [];
    cargarSaldo(widget.id);
    super.initState();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('mipmap/ic_launcher');
    final ios = IOSInitializationSettings();
    final initSetting = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: _onselectedNotification);
  }

  Future _showNotification(v, path) async {
    final andorid = AndroidNotificationDetails(
        "channelId", 'Shajedul islam shawon', 'channelDescription',
        priority: Priority.high, importance: Importance.max);
    final ios = IOSNotificationDetails();
    final notificationDetails = NotificationDetails(android: andorid, iOS: ios);

    await FlutterLocalNotificationsPlugin()
        .show(0, 'Distribuidora E&E', '$v', notificationDetails, payload: path);
  }

  Future _onselectedNotification(json) async {
    //OpenFile.open(json);
    if (json != null) {
      OpenFile.open(json);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text("Al Descargar"),
              ));
    }
  }

  var dio = Dio();

  void getPermission() async {
    print("getPermission");

    var store = await Permission.storage.status;
    print(store);

    if (!store.isGranted) {
      await Permission.storage.request();
    }
  }

  Future download2(Dio dio, String url, String savePath) async {
    //get pdf from link
    Response response = await dio.get(
      url,
      onReceiveProgress: showDownloadProgress,
      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );

    //write in download folder
    File file = File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();

    String v = 'Descarga Correcta de la Factura';
    _showNotification(v, savePath);
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[400],
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          bottomOpacity: double.infinity,
          title: const Text(
            'Mi Factura',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.download_rounded,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () async {
                getPermission();

                var path = await AndroidExternalStorage
                    .getExternalStoragePublicDirectory(
                        DirType.downloadDirectory);

                String fullPath = "$path/MiFactura_" + widget.factura + ".pdf";
                setState(() {
                  path = fullPath;
                  print(path);
                });

                download2(dio, widget.facturaurl, fullPath);
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 80),
                  child: Text(
                    "E&E",
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.only(top: 80),
                  child: Text(
                    "Factura",
                    style: TextStyle(color: Colors.grey[700], fontSize: 30.0),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 0, left: 0),
                  margin: EdgeInsets.only(left: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "DISTRIBUIDORA",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                          //textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 0),
                        child: Text(
                          "Sucre, Bolivia",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12.0,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 42),
                        child: Text(
                          "Cel: (+529) 75450473",
                          style: TextStyle(
                              color: Colors.grey[700], fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Image.asset(
                    'assets/lauch.png',
                    height: 80.0,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                widget.email,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 30, top: 15),
              child: Text(
                "$nombre $apellido",
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 30,
              ),
              child: Text(
                "Ci/Nit: $ci",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 30,
              ),
              child: Text(
                "P: (+529) $numero",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 230,
              ),
              child: Text(
                "Factura N°: " + widget.factura,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 230,
              ),
              child: Text(
                "Fecha: " + widget.fecha,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15.0,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Divider(
              color: Colors.blueGrey[900],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    "DESCRIPCION",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "CANT.",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "P. UNIT",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "TOTAL",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.blueGrey[900],
            ),

            //----------------------------------------------------------------------------------------
            ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: productsListFactura.length,
                itemBuilder: (context, int index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            productsListFactura[index].nombre +
                                ' ' +
                                productsListFactura[index].marca,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Expanded(
                        child: productsListFactura[index].cantidadUnidad == '0'
                            ? Text(
                                (int.parse(productsListFactura[index]
                                            .cantidadCaja) *
                                        int.parse(productsListFactura[index]
                                            .cantidadUnidadCaja))
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14.0,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : Text(
                                productsListFactura[index].cantidadUnidad,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                      Expanded(
                        child: Text(
                          productsListFactura[index].precioUnidad,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          productsListFactura[index].precioTotal,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }),
            Divider(
              color: Colors.blueGrey[400],
            ),
//------------------------------------------------------------------------------------------------

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Terminos y Condiciones",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Sub Total",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "$precio",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Gracias por hacer negocios con nosostros. Habrá un cargo de interés del 13%",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Total",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "$precio Bs",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ],
        ));
  }

  cargarDatos(String email) async {
    try {
      var url = Uri.parse(
          GloblaURL().urlGlobal() + 'datos_cliente.php?cliente=$email');

      final resp = await http.get(url);

      var jsonData = jsonDecode(resp.body);
      //print(jsonData);

      setState(() {
        this.nombre = jsonData[0]['cli_nombres'].toString();
        this.apellido = jsonData[0]['cli_apellidos'].toString();
        this.ci = jsonData[0]['ci'].toString();
        this.numero = jsonData[0]['cli_celular'].toString();
      });
    } catch (e) {
      print(e);
    }
  }

  cargarDatosProductos(String id) async {
    try {
      var url = Uri.parse(
          GloblaURL().urlGlobal() + 'datos_productos_factura.php?id=$id');

      final resp = await http.get(url);

      var jsonData = jsonDecode(resp.body);
      //print(jsonData);
      List<ProductosFactura> listaux = [];

      if (jsonData == null) {
        productsListFactura = [];
      } else {
        //print(jsonData);
        for (var item in jsonData) {
          listaux.add(ProductosFactura.fromJson(item));
        }

        setState(() {
          productsListFactura = listaux;
        });
      }
    } catch (e) {
      print(e);

      setState(() {
        productsListFactura = [];
      });
    }
  }

  cargarSaldo(String id) async {
    try {
      var url = Uri.parse(GloblaURL().urlGlobal() + 'fatura_saldo.php?id=$id');

      final resp = await http.get(url);

      var jsonData = jsonDecode(resp.body);
      //print(jsonData);

      setState(() {
        this.precio = jsonData[0]['PrecioTotal'].toString();
      });
    } catch (e) {
      print(e);
    }
  }
}
