class Coeficiente {
  final String condicao;
  final double maximoPasseio;
  final double minimoPasseio;
  final double maximoCaminhao;
  final double minimoCaminhao;

  Coeficiente(this.condicao, this.maximoPasseio, this.minimoPasseio,
      this.maximoCaminhao, this.minimoCaminhao);

  @override
  String toString() {
    return '$condicao (Passeio Máximo: $maximoPasseio, Passeio Mínimo: $minimoPasseio, Caminhão Máximo: $maximoCaminhao, Caminhão Mínimo: $minimoCaminhao)';
  }
}
