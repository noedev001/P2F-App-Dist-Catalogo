import 'package:distribuidoraeye/api/api_login.dart';
import 'package:distribuidoraeye/screens/inicio/custom_widgeth.dart';
import 'package:distribuidoraeye/screens/inicio/registro_ususairo.dart';
import 'package:distribuidoraeye/screens/principal/home.dart';
import 'package:distribuidoraeye/services/login_comprobar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final String token;
  Login(this.token);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String message = '';

  GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          HeroImage(
            imgHeight: MediaQuery.of(context).size.height * 0.32,
          ),
          Expanded(
              child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(fontSize: 20)),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'El email no puede estar vacío';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 20)),
                        controller: passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'El password no puede estar vacío';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Nuevo Usuario?'),
                          // ignore: deprecated_member_use
                          FlatButton(
                            child: Text(
                              'Registrarse',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return NuevoUsuario(widget.token);
                              }));
                            },
                          )
                        ],
                      ),
                      CustomButton(
                        onBtnPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var email = emailController.text;
                            var password = passwordController.text;

                            setState(() {
                              message = 'Cargando....';
                            });
                            var rsp =
                                await loginUser(email, password, widget.token);
                            print(rsp);
                            if (rsp.containsKey('status')) {
                              setState(() {
                                message = rsp['status_text'];
                              });
                              if (rsp['status'] == 1) {
                                guardarDatos(
                                  rsp['user_arr']['cli_usuario'],
                                );
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return HomePage(
                                      username: rsp['user_arr']['cli_usuario']);
                                }));
                              }
                            } else {
                              setState(() {
                                message = 'Error al Iniciar';
                              });
                            }
                          }
                        },
                        btnText: 'Iniciar',
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(message),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _googleSignIn.signIn().then((userData) {
                                setState(() {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return LoginCrear(
                                        userData, 0, widget.token);
                                  }));

                                  //print(userData);
                                });
                              }).catchError((e) {
                                print(
                                    'accessooooooooooooooooo erooooooooooooooorrr');
                                print(e);
                                Fluttertoast.showToast(
                                    backgroundColor: Colors.grey[900],
                                    textColor: Colors.white,
                                    msg: "Error Al Autenticar Con Google",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM);
                              });
                            },
                            child: Image.asset(
                              'assets/google.png',
                              height: 55,
                              width: 55,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              _login();
                            },
                            child: Image.asset(
                              'assets/facebook.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  Future<void> _login() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();

      setState(() {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return LoginCrear(userData, 1, widget.token);
        }));
      });
    } else {
      Fluttertoast.showToast(
          backgroundColor: Colors.grey[900],
          textColor: Colors.white,
          msg: "Error Al Autenticar Con Facebook",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    }
  }

  Future<void> guardarDatos(email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('login', '3');

    /*print(
        "===========================imprimir sharepref ===========================");
    print(prefs.getString(email));*/
  }
}
