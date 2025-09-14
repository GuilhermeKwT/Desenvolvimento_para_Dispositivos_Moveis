import 'package:apk_invertexto/service/invertexto_service.dart';
import 'package:flutter/material.dart';

class PorExtensoPage extends StatefulWidget {
  const PorExtensoPage({super.key});

  @override
  State<PorExtensoPage> createState() => _PorExtensoPageState();
}

class _PorExtensoPageState extends State<PorExtensoPage> {
  String? campo;
  String? resultado;
  String moeda = "BRL";
  final apiService = InvertextoService();
  Future<Map<String, dynamic>>? _future;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Digite um número',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white, fontSize: 18),
              onChanged: (value) {
                setState(() {
                  campo = value;
                  _future = apiService.convertePorExtenso(campo, moeda);
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Moeda:',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(width: 20),
                DropdownButton<String>(
                  value: moeda,
                  dropdownColor: Colors.black,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  items:
                      <String>[
                        'ARS',
                        'BOB',
                        'BRL',
                        'CLP',
                        'COP',
                        'CUP',
                        'EUR',
                        'GBP',
                        'JPY',
                        'MXN',
                        'PYG',
                        'USD',
                        'UYU',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      moeda = newValue!;
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: _future == null
                  ? Container()
                  : FutureBuilder(
                      future: _future,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return Container(
                              width: 200,
                              height: 200,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 8.0,
                              ),
                            );
                          default:
                            if (snapshot.hasError) {
                              String errorMsg = 'Erro desconhecido.';
                              if (snapshot.error.toString().contains('401')) {
                                errorMsg =
                                    'Token de acesso inválido ou ausente.';
                              } else if (snapshot.error.toString().contains(
                                    '404',
                                  ) ||
                                  snapshot.error.toString().contains(
                                    'conexão',
                                  )) {
                                errorMsg = 'Erro de conexão.';
                              } else if (snapshot.error.toString().contains(
                                '422',
                              )) {
                                errorMsg = 'Valor ausente ou inválido.';
                              }
                              return Center(
                                child: Text(
                                  errorMsg,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            } else {
                              return exibeResultado(context, snapshot);
                            }
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget exibeResultado(BuildContext context, AsyncSnapshot snapshot) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        snapshot.data["text"] ?? '',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
