import 'package:distribuidoraeye/api/api_login_facebook.dart';
import 'package:distribuidoraeye/screens/inicio/login.dart';
import 'package:distribuidoraeye/screens/principal/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCrear extends StatefulWidget {
  final variable;
  final int iden;
  final String token;
  const LoginCrear(this.variable, this.iden, this.token);

  @override
  _LoginCrearState createState() => _LoginCrearState();
}

class _LoginCrearState extends State<LoginCrear> {
  @override
  void initState() {
    print(widget.variable.toString());
    if (widget.iden == 0) {
      comprobarCuenta(
        widget.variable.email.toString(),
        widget.variable.id.toString(),
        widget.variable.displayName.toString(),
        widget.variable.photoUrl.toString(),
        widget.token.toString(),
        widget.iden,
      );
    } else {
      comprobarCuenta(
        widget.variable['email'].toString(),
        widget.variable['id'].toString(),
        widget.variable['name'].toString(),
        widget.variable['picture']['data']['url'].toString(),
        widget.token.toString(),
        widget.iden,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  comprobarCuenta(String email, String password, String nombre, String foto,
      String token, int i) async {
    var res = await loginFacebook(email, password, nombre, foto, token);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      print(res);
      if (res['acceso'] == 100) {
        guardarDatos(email, i);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomePage(username: email);
        }));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Login(widget.token);
        }));
      }
    });
  }

  Future<void> guardarDatos(email, i) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('login', i.toString());
  }
}
