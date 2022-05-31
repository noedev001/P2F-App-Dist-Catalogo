import 'package:distribuidoraeye/screens/inicio/intro.dart';
import 'package:distribuidoraeye/screens/principal/home.dart';
import 'package:distribuidoraeye/screens/principal/pagos_cuentas.dart';
import 'package:distribuidoraeye/screens/principal/productos_adquiridos.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'custom_widgeth.dart';

class Inicio extends StatefulWidget {
  final String token, tipo;
  const Inicio(this.token, this.tipo);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  late String email;
  @override
  void initState() {
    //guardarDatos('correo');
    mostrardatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Stack(
        children: [
          Positioned(
              top: 0,
              child: HeroImage(
                imgHeight: MediaQuery.of(context).size.height * 0.95,
              )),
          Positioned(
              top: 150,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.32,
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    Text(
                      'Bienvenido',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              )),
          Positioned(
              bottom: 4,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.38,
                padding: EdgeInsets.fromLTRB(30, 10, 20, 10),
                child: Column(
                  children: [
                    Text(
                      'Distribuidora E&E ',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              )),
          Positioned(
              bottom: 4,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.32,
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    Text(
                      'Productos en Linea',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              )),
          Positioned(
            bottom: -30,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.32,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: [
                  Text(
                    'GRACIAS POR SU CONFIANZA',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 100,
              left: 160,
              child: Image.asset(
                'assets/car.gif',
                //imgHeight: MediaQuery.of(context).size.height * 0.95,
                height: MediaQuery.of(context).size.height * 0.10,
              )),
        ],
      ),
    );
  }

  Future<void> mostrardatos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    email = prefs.getString('email').toString();

    await Future.delayed(const Duration(seconds: 3));

    //print(email);
    if (prefs.getString('email') != '') {
      if (prefs.getString('email') != null) {
        if (widget.tipo != '') {
          if (widget.tipo == "PagoFecha" || widget.tipo == "Pago") {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PagosCuentas(email);
            }));
          }

          if (widget.tipo == "Productos Nuevos" || widget.tipo == "Productos") {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomePage(username: email);
            }));
          }

          if (widget.tipo == "Factura") {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProductosAdquiridos(email);
            }));
          }
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HomePage(username: email);
          }));
        }
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return IntroPage(widget.token);
        }));
      }
    }
  }
}
