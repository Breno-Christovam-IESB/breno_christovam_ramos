// Define a classe `Disciplina` que representa uma disciplina acadêmica.
class Disciplina {
  // Identificador único da disciplina.
  int id;

  // Nome da disciplina.
  String nome;

  // Indica se a disciplina é anual (true) ou semestral (false).
  bool isAnual;

  // Construtor da classe `Disciplina`, que requer o ID, nome e se é anual.
  Disciplina({required this.id, required this.nome, required this.isAnual});

  // Converte a instância de `Disciplina` em um mapa (Map) para armazenar em banco de dados.
  Map<String, dynamic> toMap() {
    return {
      // Mapeia o ID da disciplina.
      'id': id,

      // Mapeia o nome da disciplina.
      'nome': nome,

      // Mapeia se a disciplina é anual; armazena 1 se for anual, 0 caso contrário.
      'isAnual': isAnual ? 1 : 0, // Armazenando como INTEGER
    };
  }

  // Constrói uma instância de `Disciplina` a partir de um mapa (Map) extraído do banco de dados.
  factory Disciplina.fromMap(Map<String, dynamic> map) {
    return Disciplina(
      // Inicializa o ID com o valor extraído do mapa.
      id: map['id'],

      // Inicializa o nome com o valor extraído do mapa.
      nome: map['nome'],

      // Converte o valor inteiro armazenado em `isAnual` de volta para booleano.
      isAnual: map['isAnual'] == 1, // Convertendo de INTEGER para booleano
    );
  }
}