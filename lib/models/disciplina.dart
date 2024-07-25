class Disciplina {
  int id;
  String nome;
  bool isAnual;

  Disciplina({required this.id, required this.nome, required this.isAnual});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'isAnual': isAnual ? 1 : 0, // Armazenando como INTEGER
    };
  }

  factory Disciplina.fromMap(Map<String, dynamic> map) {
    return Disciplina(
      id: map['id'],
      nome: map['nome'],
      isAnual: map['isAnual'] == 1, // Convertendo de INTEGER para booleano
    );
  }
}