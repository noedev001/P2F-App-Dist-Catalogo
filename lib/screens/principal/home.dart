import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:distribuidoraeye/api/api_producto_general.dart';
import 'package:distribuidoraeye/api/api_productos_populares.dart';
import 'package:distribuidoraeye/general/url.dart';
import 'package:distribuidoraeye/main.dart';
import 'package:distribuidoraeye/model/producto_oferta.dart';
import 'package:distribuidoraeye/model/productos.dart';
import 'package:distribuidoraeye/screens/carrito/tienda_carrito.dart';
import 'package:distribuidoraeye/screens/menu/contactos.dart';
import 'package:distribuidoraeye/screens/menu/pedidos_hecho.dart';
import 'package:distribuidoraeye/screens/menu/perfil.dart';
import 'package:distribuidoraeye/screens/principal/pagos_cuentas.dart';
import 'package:distribuidoraeye/screens/principal/productos_adquiridos.dart';
import 'package:distribuidoraeye/screens/productos/producto_card.dart';
import 'package:distribuidoraeye/screens/productos/producto_detalle.dart';
import 'package:distribuidoraeye/screens/productos/productos_ofertas_card.dart';
import 'package:distribuidoraeye/services/notificaciones.dart';
import 'package:distribuidoraeye/services/producto_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String username;
  HomePage({required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _advancedDrawerController = AdvancedDrawerController();

  final List categoriaList = [
    "Productos Nuevos",
    "General",
    "Populares",
    "Descuentos",
    "Menos Costosos",
    "Mas Costosos"
  ];

  late bool isVisible;
  late bool isVisible1;
  late bool isVisible2;
  late bool isVisible3;
  late bool isVisible4;
  late bool isVisible5;

  late bool loadingNuevo;
  late bool loadingGeneral;
  late bool loadingPopular;
  late bool loadingOferta;
  late bool loading4;
  late bool loading5;

  late List<Product> listProductoNuevo;
  late List<Product> listGengeral;
  late List<Product> listProductoPopular;
  late List<ProductOferta> productsListOfert;
  late List<Product> listproduct4;
  late List<Product> listproduct5;

  var selectedIndex = 0;
  late String numero;
  late String not;
  late String foto;
  late String nombreCompleto;

  late Product productoSeleccionado;
  late List<Product> historial;
  late bool aviso1 = true;

  late String textoaviso;

  @override
  void initState() {
    mostrardatos();
    isVisible = true;
    isVisible1 = false;
    isVisible2 = false;
    isVisible3 = false;
    isVisible4 = false;
    isVisible5 = false;
    loadingNuevo = true;
    loadingGeneral = true;
    loadingPopular = true;
    loadingOferta = true;
    loading4 = true;
    loading5 = true;

    //aviso = false;

    listProductoNuevo = [];
    listGengeral = [];
    listProductoPopular = [];
    productsListOfert = [];
    listproduct4 = [];
    listproduct5 = [];

    historial = [];

    numero = '0';
    not = '0';
    foto = '';
    nombreCompleto = '';
    textoaviso = '';

    _cargarDatos(widget.username);

    _carritoNotifi(widget.username);

    _carritoNotifiHecho(widget.username);

    _cargarNuevoProductos();
    _cargarProducGeneral();
    _cargarProducPopular(widget.username);
    _cargarProducOferta();
    _cargarProduct4();
    _cargarProduct5();

    _cargarTexto(widget.username);

    super.initState();
  }

  Widget _categorias() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 35.0,
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
                  isVisible3 = false;
                  isVisible4 = false;
                  isVisible5 = false;
                }
                if (index == 1) {
                  isVisible = false;
                  isVisible1 = true;
                  isVisible2 = false;
                  isVisible3 = false;
                  isVisible4 = false;
                  isVisible5 = false;
                }
                if (index == 2) {
                  isVisible = false;
                  isVisible1 = false;
                  isVisible2 = true;
                  isVisible3 = false;
                  isVisible4 = false;
                  isVisible5 = false;
                }
                if (index == 3) {
                  isVisible = false;
                  isVisible1 = false;
                  isVisible2 = false;
                  isVisible3 = true;
                  isVisible4 = false;
                  isVisible5 = false;
                }
                //----Umentar
                if (index == 4) {
                  isVisible = false;
                  isVisible1 = false;
                  isVisible2 = false;
                  isVisible3 = false;
                  isVisible4 = true;
                  isVisible5 = false;
                }
                if (index == 5) {
                  isVisible = false;
                  isVisible1 = false;
                  isVisible2 = false;
                  isVisible3 = false;
                  isVisible4 = false;
                  isVisible5 = true;
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
                            offset: Offset(0, 15),
                          )
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
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProductosAdquiridos(widget.username);
                }));
              }),
          SizedBox(
            width: 45.0,
          ),
          IconButton(
              icon: Icon(Icons.view_list_rounded),
              color: Colors.white,
              iconSize: 20.0,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PagosCuentas(widget.username);
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

  Future<void> mostrardatos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //aviso = prefs.getString('email').toString();

    if (prefs.getBool('aviso') != null) {
      aviso1 = prefs.getBool('aviso')!;
    } else {
      aviso1 = false;
    }
  }

  Future<void> guardarDatos(avisoaux) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('aviso', avisoaux);
    print("se guardo aviso $avisoaux");
    print(prefs.getBool('aviso'));
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
                    widget.username,
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
                        ),
                  trailing: Container(
                    width: 60,
                    height: 30,
                    child: FlutterSwitch(
                      width: 60.0,
                      height: 25.0,
                      valueFontSize: 10.0,
                      toggleSize: 10.0,
                      value: aviso1,
                      borderRadius: 18.0,
                      padding: 6.0,
                      showOnOff: true,
                      activeColor: Theme.of(context).primaryColor,
                      activeToggleColor: Colors.white,
                      inactiveToggleColor: Theme.of(context).primaryColor,
                      onToggle: (val) {
                        setState(() {
                          guardarDatos(val);
                          aviso1 = val;
                        });
                      },
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return HomePage(
                          username: widget.username,
                        );
                      },
                    ));
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
                        email: widget.username,
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
                          widget.username,
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
                      return NotificacionesDis(widget.username);
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
                    showModalErrores(context, widget.username);
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
                  /*trailing: Switcher(
                    value: aviso1,
                    size: SwitcherSize.small,
                    switcherButtonRadius: 50,
                    enabledSwitcherButtonRotate: true,
                    iconOff: Icons.lock,
                    iconOn: Icons.lock_open,
                    colorOff: Colors.blueGrey.withOpacity(0.3),
                    colorOn: Colors.blue,
                    onChanged: (aviso1) {
                      guardarDatos(aviso1);
                    },
                  ),*/
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
          onPressed: () {},
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
          actions: [
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
            ),
          ],
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
                          "Nuestro",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 30.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Productos",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.teal[300],
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                              //color: Colors.blueGrey[900],
                              color: Color(0xFF263238),
                              blurRadius: 50.0,
                              offset: Offset(0, 25),
                              spreadRadius: -40)
                        ]),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        final producto = await showSearch(
                            context: context,
                            delegate:
                                ProductoSearchDelegate('Bucar..', historial));

                        setState(() {
                          if (producto != null) {
                            this.productoSeleccionado = producto;
                            this.historial.insert(0, producto);
                          }
                        });
                        if (producto != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductoDetalle(
                                  widget.username, productoSeleccionado),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            _categorias(),
            _aviso(),
            _espacio(),
            _catalogo(),
            _catalogo1(),
            _catalogo2(),
            _catalogo3(),
            _catalogo4(),
            _catalogo5(),
          ],
        ),
      ),
    );
  }

  Widget _espacio() {
    return Visibility(
        visible: !aviso1,
        child: SizedBox(
          height: 50,
        ));
  }

  Widget _aviso() {
    return Visibility(
      visible: aviso1,
      child: Container(
        //width: 20.0,
        height: 50,
        margin: EdgeInsets.only(left: 10, right: 10),
        //color: Colors.amber,
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 16.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText('$textoaviso'),
            ],
            //totalRepeatCount: 1000,
            pause: Duration(milliseconds: 2000),
            repeatForever: true,
          ),
        ),
      ),
    );
  }

  Widget _catalogo() {
    return Visibility(
      visible: isVisible,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        height: 370.0,
        child: _listcargarNuevoProducto(),
      ),
    );
  }

  _listcargarNuevoProducto() {
    if (loadingNuevo) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listProductoNuevo.length,
        itemBuilder: (BuildContext context, int index) {
          return ProductoCard(listProductoNuevo[index], widget.username);
        });
  }

  Widget _catalogo1() {
    return Visibility(
      visible: isVisible1,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        height: 370.0,
        child: _listcargarGeneral(),
      ),
    );
  }

  _listcargarGeneral() {
    if (loadingGeneral) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listGengeral.length,
        itemBuilder: (BuildContext context, int index) {
          return ProductoCard(listGengeral[index], widget.username);
        });
  }

  Widget _catalogo2() {
    return Visibility(
      visible: isVisible2,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        height: 370.0,
        child: _listcargarPopular(),
      ),
    );
  }

  _listcargarPopular() {
    if (loadingGeneral) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listProductoPopular.length,
        itemBuilder: (BuildContext context, int index) {
          return ProductoCard(listProductoPopular[index], widget.username);
        });
  }

  Widget _catalogo3() {
    return Visibility(
      visible: isVisible3,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        height: 370.0,
        child: _listcargarOferta(),
      ),
    );
  }

  _listcargarOferta() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: productsListOfert.length,
        itemBuilder: (BuildContext context, int index) {
          return ProductoOfertaCard(productsListOfert[index], widget.username);
        });
  }

  Widget _catalogo4() {
    return Visibility(
      visible: isVisible4,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        height: 370.0,
        child: _listcargar4(),
      ),
    );
  }

  _listcargar4() {
    if (loadingNuevo) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listproduct4.length,
        itemBuilder: (BuildContext context, int index) {
          return ProductoCard(listproduct4[index], widget.username);
        });
  }

  Widget _catalogo5() {
    return Visibility(
      visible: isVisible5,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        height: 370.0,
        child: _listcargar5(),
      ),
    );
  }

  _listcargar5() {
    if (loadingNuevo) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listproduct5.length,
        itemBuilder: (BuildContext context, int index) {
          return ProductoCard(listproduct5[index], widget.username);
        });
  }

  _cargarNuevoProductos() async {
    try {
      var url = Uri.parse(GloblaURL().urlGlobal() + 'nuevos_productos.php');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);

        List<Product> listauxiliar = [];

        //print(jsonData);

        for (var item in jsonData["NuevosProduct"]) {
          listauxiliar.add(Product.fromJson(item));
        }
        setState(() {
          listProductoNuevo = listauxiliar;
          loadingNuevo = false;
        });
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      print("nuevos");
      listProductoNuevo = [];
      loadingNuevo = false;
    }
  }

  _cargarProducGeneral() async {
    var listGeneral = await generalProductos();
    List<Product> lisaux = [];
    for (var item in listGeneral['ProducGeneral']) {
      lisaux.add(Product.fromJson(item));
    }
    setState(() {
      listGengeral = lisaux;
      loadingGeneral = false;
    });
  }

  _cargarProducPopular(String user) async {
    var lisPopular = await popularesProductos(user);
    List<Product> listaux = [];
    for (var item in lisPopular['ProductosParaTi']) {
      listaux.add(Product.fromJson(item));
    }
    setState(() {
      listProductoPopular = listaux;
      loadingPopular = false;
    });
  }

  _cargarProducOferta() async {
    try {
      var url = Uri.parse(GloblaURL().urlGlobal() + 'oferta_productos.php');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);

        List<ProductOferta> listaux = [];

        for (var item in jsonData["ProductosOferta"]) {
          listaux.add(ProductOferta.fromJson(item));
        }
        setState(() {
          productsListOfert = listaux;
          loadingOferta = false;
        });
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      print("oferta");
      print(e);
    }
  }

  _cargarProduct4() async {
    try {
      var url = Uri.parse(GloblaURL().urlGlobal() + 'menos_costoso.php');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);

        List<Product> listauxiliar = [];

        //print(jsonData);

        for (var item in jsonData["Product"]) {
          listauxiliar.add(Product.fromJson(item));
        }
        setState(() {
          listproduct4 = listauxiliar;
          loading4 = false;
        });
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      print("nuevos");
      listproduct4 = [];
      loading4 = false;
    }
  }

  _cargarProduct5() async {
    try {
      var url = Uri.parse(GloblaURL().urlGlobal() + 'mas_caros.php');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);

        List<Product> listauxiliar = [];

        //print(jsonData);

        for (var item in jsonData["Product"]) {
          listauxiliar.add(Product.fromJson(item));
        }
        setState(() {
          listproduct5 = listauxiliar;
          loading5 = false;
        });
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      print("nuevos");
      listproduct5 = [];
      loading5 = false;
    }
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
      setState(() {
        numero = '0';
      });
      print("carrtio");
      print(e);
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
        //print('aki');
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

  _cargarTexto(String cliente) async {
    try {
      var url =
          Uri.parse(GloblaURL().urlGlobal() + 'avisos.php?cliente=' + cliente);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        print(jsonData);
        String aux = jsonData['Datos'][0]['aviso'].toString();

        setState(() {
          textoaviso = aux;
          print(aux);
        });
      } else {
        throw Exception("Fallo la Conexión");
      }
    } catch (e) {
      textoaviso = '';
      print(e);
      print('ojoo');
    }
  }
}
