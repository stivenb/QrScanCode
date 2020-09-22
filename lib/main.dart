import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escaneando el codigo papu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Escaneando el codigo papu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _barcode = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lector QR flutter'),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10.0),
                child: RaisedButton(
                  color: Colors.amber,
                  textColor: Colors.black,
                  splashColor: Colors.blueGrey,
                  onPressed: scan,
                  child: const Text('Scanear el código QR.'),
                ),
              ),
              GestureDetector(
                child: Text(
                  _barcode,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
                onTap: _launchURL,
              ),
            ],
          ),
        ));
  }

  Future scan() async {
    try {
      var barcode = await BarcodeScanner.scan();
      setState(() => this._barcode = barcode.rawContent);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this._barcode = 'El usuario no dio permiso para el uso de la cámara!';
        });
      } else {
        setState(() => this._barcode = 'Error desconocido $e');
      }
    } on FormatException {
      setState(() => this._barcode =
          'nulo, el usuario presionó el botón de volver antes de escanear algo)');
    } catch (e) {
      setState(() => this._barcode = 'Error desconocido : $e');
    }
  }

  _launchURL() async {
    if (await canLaunch(_barcode)) {
      await launch(_barcode);
    } else {
      throw 'Could not launch $_barcode';
    }
  }
}
