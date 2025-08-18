enum Pessoa{
    {nome, idade}
}

void main(){
    //1
    List<String> frutas = ['banana', 'maçã', 'tangerina', 'uva', 'pera'];
    print(frutas);

    //2
    print(frutas[2]);
    
    //3
    frutas.add('laranja');
    print(frutas);
    frutas.remove('maçã');
    print(frutas);

    //4
    for (int i = 0; i < frutas.length; i++){
        print(frutas[i].toUpperCase());
    }

    //5
    for (String fruta in frutas){
        print(fruta.toLowerCase());
    }

    //6
    List<String> frutasComA = frutas.where((fruta) => fruta[0] == 'a').toList();
    print(frutasComA);

    //7
    Map<String, double> precosFrutas = {
        'banana': 2.5,
        'tangerina': 1.5,
        'uva': 4.0,
        'pera': 2.8,
        'laranja': 3.2,
    };
    print(precosFrutas);

    //8
    for (String fruta in frutas) {
        if (precosFrutas.containsKey(fruta)) {
            print('O preço da $fruta é R\$${precosFrutas[fruta]}');
        } else {
            print('Preço não disponível para $fruta');
        }
    }

    //9
    List<int> numeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    List<int> pares = (numeros) {
        List<int> resultado = [];
        for (int numero in numeros) {
            if (numero % 2 == 0) {
                resultado.add(numero);
            }
        }
        return resultado;
    }
    print('Números pares: $pares');

    //10
    List<Pessoa> pessoas = [
        Pessoa(nome: 'Bruno', idade: 20),
        Pessoa(nome: 'Carlos', idade: 22),
        Pessoa(nome: 'Elisa', idade: 19),
        Pessoa(nome: 'Ana', idade: 15),
        Pessoa(nome: 'João', idade: 17),
    ];
    maioresDeIdade(pessoas);
}

void maioresDeIdade(List<Pessoa> pessoas) {
    List<Pessoa> maiores = pessoas.where((pessoa) => pessoa.idade >= 18).toList();
    for (Pessoa pessoa in maiores) {
        print('${pessoa.nome} é maior de idade.');
    }
}
