enum Naipe {
  COPAS,
  OUROS,
  ESPADA,
  PAUS,
}

enum Valor {
  AS,
  DOIS,
  TRES,
  QUATRO,
  CINCO,
  SEIS,
  SETE,
  OITO,
  NOVE,
  DEZ,
  VALETE,
  RAINHA,
  REI,
}

class Carta {
  Naipe naipe;
  Valor valor;

  Carta(this.naipe, this.valor);

  @override
  String toString() {
    return '${valor.name} de ${naipe.name}';
  }
}

class Baralho {
  List<Carta> cartas = [];

  Baralho() {
    for (Naipe naipe in Naipe.values) {
      for (Valor valor in Valor.values) {
        cartas.add(Carta(naipe, valor));
      }
    }
  }

  void embaralhar() {
    cartas.shuffle();
  }

  Carta comprarCarta() {
    return cartas.removeLast();
  }

  int cartasRestantes() {
    return cartas.length;
  }
}

void main() {
  Baralho baralho = Baralho();
  baralho.embaralhar();

  for (int i = 0; i < 5; i++) {
    Carta carta = baralho.comprarCarta();
    print('$carta');
  }

  print('Cartas restantes no baralho: ${baralho.cartasRestantes()}');
}