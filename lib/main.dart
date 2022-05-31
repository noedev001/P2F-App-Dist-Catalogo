import 'package:distribuidoraeye/screens/inicio/bienvenido.dart';
import 'package:distribuidoraeye/services/push_notificaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PushNotificaciones.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  String tok = '';
  String tipo = '';

  @override
  void initState() {
    super.initState();
    tok = PushNotificaciones.token.toString();

    PushNotificaciones.messageStream.listen((event) {
      print("MyApp: $event");
      tipo = event;
      navigatorKey.currentState!.pushNamed('inicio', arguments: {tok, tipo});
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Distribuidora E&E',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.teal[300],
        accentColor: Colors.teal[300],
        brightness: Brightness.dark,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline5: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          headline4: TextStyle(
            fontSize: 20.0,
          ),
          bodyText1: TextStyle(
            fontSize: 20.0,
          ),
          bodyText2: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
      initialRoute: 'inicio',
      routes: {
        'inicio': (_) => Inicio(tok, tipo),
        //'prueba': (_) => MyHomePage(),
      },
      //home: Inicio(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
    );
  }
}
