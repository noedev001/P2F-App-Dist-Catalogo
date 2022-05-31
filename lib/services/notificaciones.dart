import 'dart:convert';

import 'package:distribuidoraeye/general/url.dart';
import 'package:distribuidoraeye/model/notificaciones.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificacionesDis extends StatefulWidget {
  final String email;
  NotificacionesDis(this.email);
  @override
  _NotificacionesDisState createState() => _NotificacionesDisState();
}

class _NotificacionesDisState extends State<NotificacionesDis> {
  late bool loading;
  late List<Notificacioes> listNotificaciones;

  @override
  void initState() {
    super.initState();
    loading = false;
    listNotificaciones = [];
    _cargarNotificacion(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificaiones"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 15.0,
          ),
          _notificacionesHechas()
        ],
      ),
    );
  }

  Widget _notificacionesHechas() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return (Expanded(
      child: Container(
        width: 100.0,
        child: ListView.builder(
            itemCount: listNotificaciones.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 120.0,
                // color: Colors.black,
                padding: EdgeInsets.only(top: 5.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 10.0,
                      child: Container(
                        height: 100.0,
                        width: 350.0,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[900],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30.0,
                      left: 50.0,
                      child: Text(
                        listNotificaciones[index].titulo,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0),
                      ),
                    ),
                    Positioned(
                      top: 55.0,
                      left: 50.0,
                      child: Container(
                        //color: Colors.blue,
                        width: 220.0,
                        child: Text(
                          listNotificaciones[index].mensaje,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 95.0,
                      left: 50.0,
                      child: Container(
                        //color: Colors.blue,
                        width: 220.0,
                        child: listNotificaciones[index].fecha == '0'
                            ? Text(
                                "hoy", //+
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 8.0),
                              )
                            : Text(
                                "hace " +
                                    listNotificaciones[index].fecha +
                                    ' dias', //+
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 8.0),
                              ),
                      ),
                    ),
                    Positioned(
                      top: 10.0,
                      right: 10.0,
                      //mainAxisAlignment: MainAxisAlignment.end,
                      child: Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(
                          //top: 30.0,
                          bottom: 0.0,
                        ),
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: listNotificaciones[index].imagen == 'x'
                              ? ClipOval(
                                  child: Image.asset(
                                    'assets/lauch.png',
                                  ),
                                )
                              : ClipOval(
                                  child: FadeInImage.assetNetwork(
                                    height: double.infinity,
                                    width: double.infinity,
                                    fadeInCurve: Curves.bounceInOut,
                                    fadeOutDuration:
                                        Duration(milliseconds: 800),
                                    placeholder: 'assets/loading.gif',
                                    image: listNotificaciones[index].imagen,
                                  ),
                                ),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 4.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    ));
  }

  _cargarNotificacion(String user) async {
    try {
      var url = Uri.parse(
          GloblaURL().urlGlobal() + 'mostrar_notificaciones.php?cliente=$user');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);

        List<Notificacioes> listaux = [];

        if (jsonData['noti'] == null) {
          setState(() {
            loading = false;
            listNotificaciones = [];
          });
        } else {
          for (var item in jsonData['noti']) {
            listaux.add(Notificacioes.fromJson(item));
          }
          setState(() {
            listNotificaciones = listaux;
            loading = false;
          });
        }
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      print(e);

      loading = false;
    }
  }
}
