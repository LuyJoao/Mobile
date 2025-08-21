enum Naipe{copas, ouros, espadas, paus}

enum Valor{as, dois, tres, quatro, cinco, seis, sete, oito, nove, dez, valete, dama, rei}

class Card {
  final Naipe naipe;
  final Valor valor;

  Card(this.naipe, this.valor);

  @override
  String toString() {
    return "${valor.name.toUpperCase()} DE ${naipe.name.toUpperCase()}";
  }
}

class Baralho {
  final List<Card> _cartas = [];

  Baralho() {
    for (var naipe in Naipe.values) {
      for (var valor in Valor.values) {
        _cartas.add(Card(naipe, valor));
      }
    }
  }

  void embaralhar() {
    _cartas.shuffle();
  }

  Card comprar() {
    if (_cartas.isEmpty) {
      throw Exception("O baralho está vazio!");
    }
    return _cartas.removeLast();
  }

  int cartasRestantes() {
    return _cartas.length;
  }
}

void main() {
  final baralho = Baralho();

  baralho.embaralhar();

  print("Suas cartas:");
  for (int i = 0; i < 5; i++) {
    print(baralho.comprar());
  }

  print("\nCartas restantes no baralho: ${baralho.cartasRestantes()}");
}
