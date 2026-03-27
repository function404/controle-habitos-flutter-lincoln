class Habito {
  String id;
  String titulo;
  String descricao;
  bool concluido;

  Habito({
    required this.id,
    required this.titulo,
    required this.descricao,
    this.concluido = false,
  });
}