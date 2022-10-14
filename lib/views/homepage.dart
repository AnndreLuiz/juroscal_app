import 'dart:math';
import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController principalTextEditingController =
      TextEditingController();
  TextEditingController rateofInterestTextEditingController =
      TextEditingController();
  TextEditingController termTextEditingController = TextEditingController();

  var _currencies = ['Real', 'Dolar', 'Euro'];

  String result = '';
  String _character = '';
  String nv = '';
  String currentValue = '';

  @override
  void initState() {
    currentValue = _currencies[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interest Calculator'),
        centerTitle: true,
        leading: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/item');
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            getImage(),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(1.0),
                    child: ListTile(
                      title: Text('Juros Simples'),
                      leading: Radio(
                        value: 'simples',
                        groupValue: _character,
                        onChanged: (value) {
                          setState(() {
                            _character = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(1.0),
                    child: ListTile(
                      title: Text('Juros Composto'),
                      leading: Radio(
                        value: 'composto',
                        groupValue: _character,
                        onChanged: (value) {
                          setState(() {
                            _character = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                controller: principalTextEditingController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Principal',
                  hintText: 'Digite uma quantidade principal ex., 1099',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CentavosInputFormatter(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                controller: rateofInterestTextEditingController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Taxa de Juros',
                  hintText: 'Digite uma taxa por ano',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CentavosInputFormatter(),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      controller: termTextEditingController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        labelText: 'Prazo',
                        hintText: 'Digite o numero de anos',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 10,
                ),
                Expanded(
                  child: DropdownButton<String>(
                    items: _currencies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: currentValue,
                    onChanged: (newValue) {
                      _setSelectedValue(newValue.toString());
                      this.nv = newValue.toString();
                      setState(() {
                        this._currencies = newValue as List<String>;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    child: Text(
                      'Calcular',
                      textScaleFactor: 1.75,
                    ),
                    onPressed: () {
                      this.result = _getEffectiveAmout(this.nv);
                      onDialogOpen(context, this.result);
                    },
                  ),
                ),
                Container(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    child: Text(
                      'Resetar',
                      textScaleFactor: 1.75,
                    ),
                    onPressed: () {
                      _reset();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _setSelectedValue(String newValue) {
    setState(() {
      this.currentValue = newValue;
    });
  }

  String _getEffectiveAmout(String newValue) {
    String newResult;
    double principal = double.parse(principalTextEditingController.text);
    double rate = double.parse(rateofInterestTextEditingController.text);
    double term = double.parse(termTextEditingController.text);

    double netpaybleAmount = 0;

    if (_character == 'simples') {
      netpaybleAmount = principal + (principal * rate * term) / 100;
    } else if (_character == 'composto') {
      netpaybleAmount = principal * pow((1 + (rate / 100)), term);
    }
    if (term == 1) {
      newResult =
          'Após $term anos, você terá que pagar o valor total = $netpaybleAmount $currentValue';
    } else {
      newResult =
          'Após $term anos, você terá que pagar o valor total = $netpaybleAmount $currentValue';
    }
    return newResult;
  }

  void _reset() {
    principalTextEditingController.text = '';
    rateofInterestTextEditingController.text = '';
    termTextEditingController.text = '';
    result = '';
    currentValue = _currencies[0];
  }

  void onDialogOpen(BuildContext context, String s) {
    var alertDialog = AlertDialog(
      title: Text('NP is selected...'),
      content: Text(s),
      backgroundColor: Colors.green,
      elevation: 8.0,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(s),
          );
        });
  }
}

Widget getImage() {
  AssetImage assetImage = AssetImage('lib/images/investimento.jpg');
  Image image = Image(
    image: assetImage,
    width: 150,
    height: 150,
  );
  return Container(
    child: image,
    margin: EdgeInsets.all(5),
  );
}
