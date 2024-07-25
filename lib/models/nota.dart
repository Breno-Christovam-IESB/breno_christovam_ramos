class Nota {
  final int id;
  final int disciplinaId;
  final double nota;
  final int bimestre;
  final String descricao; // Adicionando a descrição
  final double valor; // Adicionando o valor

  Nota({
    required this.id,
    required this.disciplinaId,
    required this.nota,
    required this.bimestre,
    required this.descricao, // Adicionando a descrição
    required this.valor, // Adicionando o valor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'disciplinaId': disciplinaId,
      'nota': nota,
      'bimestre': bimestre,
      'descricao': descricao, // Incluindo a descrição no mapa
      'valor': valor, // Incluindo o valor no mapa
    };
  }

  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map['id'],
      disciplinaId: map['disciplinaId'],
      nota: map['nota'],
      bimestre: map['bimestre'],
      descricao: map['descricao'], // Incluindo a descrição ao criar a nota
      valor: map['valor'], // Incluindo o valor ao criar a nota
    );
  }
}