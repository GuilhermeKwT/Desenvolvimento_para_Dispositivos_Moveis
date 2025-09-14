import 'package:apk_invertexto/service/invertexto_service.dart';
import 'package:flutter/material.dart';

class BuscaCepPage extends StatefulWidget {
  const BuscaCepPage({super.key});

  @override
  State<BuscaCepPage> createState() => _BuscaCepPageState();
}

class _BuscaCepPageState extends State<BuscaCepPage> {
  String? campo;
  String? resultado;
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
                labelText: 'Digite um CEP',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  campo = value;
                  _future = apiService.buscaCEP(campo);
                });
              },
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
                              )) {
                                errorMsg = 'Erro de conexão.';
                              } else if (snapshot.error.toString().contains(
                                '422',
                              )) {
                                errorMsg = 'CEP inválido.';
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
    String enderecoCompleto = '';
    if (snapshot.data != null) {
      enderecoCompleto += snapshot.data["street"] ?? "Rua não disponível";
      enderecoCompleto += "\n";
      enderecoCompleto +=
          snapshot.data["neighborhood"] ?? "Bairro não disponível";
      enderecoCompleto += "\n";
      enderecoCompleto += snapshot.data["city"] ?? "Cidade não disponível";
      enderecoCompleto += "\n";
      enderecoCompleto += snapshot.data["state"] ?? "Estado não disponível";
    }

    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        enderecoCompleto,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
