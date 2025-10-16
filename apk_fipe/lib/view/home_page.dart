import 'package:flutter/material.dart';
import 'package:apk_fipe/service/fipe_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FipeService _servicoFipe = FipeService();

  List<Map<String, dynamic>> _marcas = [];
  List<Map<String, dynamic>> _modelos = [];
  List<Map<String, dynamic>> _anos = [];

  dynamic _marcaSelecionada;
  dynamic _modeloSelecionado;
  dynamic _anoSelecionado;

  bool _carregandoMarcas = false;
  bool _carregandoModelos = false;
  bool _carregandoAnos = false;
  bool _carregandoResultado = false;

  Future<Map<String, dynamic>>? _futureResultado;

  @override
  void initState() {
    super.initState();
    _carregarMarcas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Consulta FIPE',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Marca
            Text(
              'Marca',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _carregandoMarcas
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<dynamic>(
                    initialValue: _marcaSelecionada,
                    items: _marcas
                        .map(
                          (marca) => DropdownMenuItem(
                            value: marca,
                            child: Text(marca['name'].toString()),
                          ),
                        )
                        .toList(),
                    onChanged: (marca) {
                      setState(() {
                        _marcaSelecionada = marca;
                      });
                      final id = marca['code'].toString();
                      _carregarModelos(id);
                      _carregarAnos(id);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
            const SizedBox(height: 16),

            // Modelo
            Text(
              'Modelo',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _carregandoModelos
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<dynamic>(
                    isExpanded: true,
                    initialValue: _modeloSelecionado,
                    items: _modelos.map((modelo) {
                      final text = modelo['name'].toString();
                      return DropdownMenuItem(
                        value: modelo,
                        child: Tooltip(
                          message: text,
                          child: Text(
                            text,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (modelo) {
                      setState(() {
                        _modeloSelecionado = modelo;
                      });
                      if (_anoSelecionado == null && !_carregandoAnos) {
                        final brandId = _marcaSelecionada['code'].toString();
                        final modelId = modelo['code'].toString();
                        _carregarAnos(brandId, modelId: modelId);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
            const SizedBox(height: 16),

            // Ano
            Text(
              'Ano',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _carregandoAnos
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<dynamic>(
                    isExpanded: true,
                    initialValue: _anoSelecionado,
                    items: _anos.map((ano) {
                      final text = ano['name'].toString();
                      return DropdownMenuItem(
                        value: ano,
                        child: Tooltip(
                          message: text,
                          child: Text(
                            text,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (ano) {
                      setState(() => _anoSelecionado = ano);
                      if (_modeloSelecionado == null && !_carregandoModelos) {
                        final brandId = _marcaSelecionada['code'].toString();
                        final anoId = ano['code'].toString();
                        _carregarModelos(brandId, anoId: anoId);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: _carregandoResultado ? null : _pesquisarValor,
              icon: _carregandoResultado
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: const Text('Pesquisar'),
            ),

            const SizedBox(height: 24),

            FutureBuilder<Map<String, dynamic>>(
              future: _futureResultado,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Erro ao carregar resultado',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        color: Theme.of(context).colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(snapshot.error.toString()),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: _carregandoResultado
                                    ? null
                                    : _pesquisarValor,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                _carregandoResultado = false;
                if (!snapshot.hasData) return const SizedBox.shrink();

                final data = snapshot.data!;
                final resultado = _mapearResultadoVisivel(data);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Resultado',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    exibirResultado(resultado),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _carregarMarcas() async {
    setState(() {
      _carregandoMarcas = true;
    });
    try {
      final res = await _servicoFipe.buscaMarcas();
      setState(() {
        _marcas = res;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar marcas: $e')));
      rethrow;
    } finally {
      setState(() {
        _carregandoMarcas = false;
      });
    }
  }

  Future<void> _carregarModelos(String brandId, {String? anoId}) async {
    setState(() {
      _carregandoModelos = true;
      _modelos = [];
      _modeloSelecionado = null;
    });
    try {
      final res = anoId == null
          ? await _servicoFipe.buscaModelos(brandId)
          : await _servicoFipe.buscaModelosMarcaAno(brandId, anoId);
      setState(() {
        _modelos = res;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar modelos: $e')));
      rethrow;
    } finally {
      setState(() {
        _carregandoModelos = false;
      });
    }
  }

  Future<void> _carregarAnos(String brandId, {String? modelId}) async {
    setState(() {
      _carregandoAnos = true;
      _anos = [];
      _anoSelecionado = null;
    });
    try {
      final res = modelId == null
          ? await _servicoFipe.buscaAnosMarca(brandId)
          : await _servicoFipe.buscaAnosModelo(brandId, modelId);
      setState(() {
        _anos = List<Map<String, dynamic>>.from(res);
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar anos: $e')));
      rethrow;
    } finally {
      setState(() {
        _carregandoAnos = false;
      });
    }
  }

  Future<void> _pesquisarValor() async {
    if (_marcaSelecionada == null ||
        _modeloSelecionado == null ||
        _anoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione marca, modelo e ano antes de pesquisar'),
        ),
      );
      return;
    }

    final marcaId = _marcaSelecionada['code'].toString();
    final modeloId = _modeloSelecionado['code'].toString();
    final anoId = _anoSelecionado['code'].toString();

    setState(() {
      _carregandoResultado = true;
      _futureResultado = _servicoFipe.buscaValorVeiculo(
        marcaId,
        modeloId,
        anoId,
      );
    });
  }

  // Converte o JSON bruto da API para um mapa legível ao usuário
  Map<String, String> _mapearResultadoVisivel(Map<String, dynamic> data) {
    final Map<String, String> out = {};

    void add(String chave, dynamic valor) {
      if (valor == null) return;
      out[chave] = valor.toString();
    }

    add('Marca', data['brand']);
    add('Código FIPE', data['codeFipe']);
    add('Combustível', data['fuel']);
    add('Modelo', data['model']);
    add('Ano do modelo', data['modelYear']);
    add('Preço', data['price']);
    add('Mês de referência', data['referenceMonth']);

    return out;
  }

  Widget exibirResultado(Map<String, String> resultado) {
    return Card(
      color: Theme.of(context).colorScheme.primary.withAlpha(100),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: resultado.entries.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      e.key,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(flex: 7, child: Text(e.value)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
