void ex1(int a, int b, int c){
  print ((a + b) < c ? "A soma de A e B é menor que C" : "A soma de A e B não é menor que C");
}

void ex2(int x){
  print (x % 2 == 0 ? "O número é par" : "O número é ímpar");
}

int ex3(int a, int b) => a == b ? a + b : a * b;

void ex4(int a, int b, int c){
  List<int> lista = [a, b, c];
  lista.sort();
  for (int item in lista.reversed) {
    print(item);
  }
}

void ex5(){
  int sum = 0;
  for (int i = 1; i <= 500; i++) {
    if (i % 2 != 0 && i % 3 == 0) {
      sum += i;
    }
  }
  print("A soma dos números ímpares e múltiplos de 3 entre 1 e 500 é: $sum");
}

void ex6(){
  for (int i = 100; i <= 200; i++) {
    i % 2 != 0 ? print("$i") : null;
  }
}

void ex7(int n){
  for(int i = 1; i <= 10; i++){
    print("$n x $i = ${n * i}");
  }
}

void ex8(int n){
  int fatorial = 1;
  String saida = "$n! = ";
  for (int i = 1; i <= n; i++) {
    fatorial *= i;
    saida += "$i${i < n ? " x " : ""}";
  }
  saida += " = $fatorial";
  print(saida);
}

void main() {
  ex1(1, 2, 4);
  ex2(3);
  print(ex3(5, 5));
  ex4(3, 1, 2);
  ex5();
  ex6();
  ex7(7);
  ex8(5);
}