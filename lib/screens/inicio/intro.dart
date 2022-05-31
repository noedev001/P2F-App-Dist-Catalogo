import 'package:distribuidoraeye/screens/inicio/custom_widgeth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class IntroPage extends StatefulWidget {
  final String token;
  IntroPage(this.token);
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0,
              child: HeroImage(
                imgHeight: MediaQuery.of(context).size.height * 0.95,
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
              bottom: 4,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.18,
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      btnText: 'Comenzar',
                      onBtnPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Login(widget.token);
                        }));
                      },
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
