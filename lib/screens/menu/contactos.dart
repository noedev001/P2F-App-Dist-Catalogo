import 'package:flutter/material.dart';

class ContactosDis extends StatefulWidget {
  ContactosDis();
  @override
  _ContactosDisState createState() => _ContactosDisState();
}

class _ContactosDisState extends State<ContactosDis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contáctanos",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(top: 50.0, left: 10.0),
            child: Text(
              "Atención: 24 Horas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 8.0, left: 10.0),
            child: Text(
              "Direccion: Calle España Nº 150",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/wat.png',
                  height: 40,
                ),
                Container(
                  child: Text(
                    "12345678",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                Image.asset(
                  'assets/wat.png',
                  height: 40,
                ),
                Container(
                  child: Text(
                    "87654321",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 40.0,
            ),
            child: Center(
              child: Text(
                "Comunicate con Nosotros",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "Distribuidor 1: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Icon(Icons.call),
                Image.asset(
                  'assets/wat.png',
                  height: 35,
                ),
                Container(
                  child: Text(
                    "12345678",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "Distribuidor 2: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Icon(Icons.call),
                Image.asset(
                  'assets/wat.png',
                  height: 35,
                ),
                Container(
                  child: Text(
                    "12345678",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "Distribuidor 3: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Icon(Icons.call),
                Image.asset(
                  'assets/wat.png',
                  height: 35,
                ),
                Container(
                  child: Text(
                    "12345678",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "Distribuidor 4: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Icon(Icons.call),
                Image.asset(
                  'assets/wat.png',
                  height: 35,
                ),
                Container(
                  child: Text(
                    "12345678",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "Pagina Web: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Text(
                    "www.distribuidoraee.com.bo",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/facebook.png',
                  height: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Text(
                    "Distribuidor - Sucre",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(
              top: 10.0,
            ),
            child: Center(
              child: Text(
                "Versión 1.0.0 Distribuidora E&E",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
