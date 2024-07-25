class Nota {
  final int id; // Adicionando o id
  final int disciplinaId; // Adicionando a disciplina
  final double nota; // Adicionando a nota
  final int bimestre; // Adicionando o bimestre
  final String descricao; // Adicionando a descrição
  final double valor; // Adicionando o valor

  Nota({
    required this.id, // Adicionando o id
    required this.disciplinaId, // Adicionando a disciplina
    required this.nota, // Adicionando a nota
    required this.bimestre, // Adicionando o bimestre
    required this.descricao, // Adicionando a descrição
    required this.valor, // Adicionando o valor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Incluindo o id no mapa
      'disciplinaId': disciplinaId, // Incluindo a disciplina no mapa
      'nota': nota, // Incluindo a nota no mapa
      'bimestre': bimestre, // Incluindo o bimestre no mapa
      'descricao': descricao, // Incluindo a descrição no mapa
      'valor': valor, // Incluindo o valor no mapa
    };
  }

  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map['id'], // Incluindo o id ao criar a nota
      disciplinaId: map['disciplinaId'], // Incluindo a disciplina ao criar a nota
      nota: map['nota'], // Incluindo a nota ao criar a nota
      bimestre: map['bimestre'], // Incluindo o bimestre ao criar a nota
      descricao: map['descricao'], // Incluindo a descrição ao criar a nota
      valor: map['valor'], // Incluindo o valor ao criar a nota
    );
  }
}