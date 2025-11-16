class Abastecimento {
  final String id;
  final String veiculoId;
  final DateTime data;
  final double litros;
  final double valorPago;
  final int km;
  final String combustivel;
  final String? obs;

  Abastecimento({
    required this.id,
    required this.veiculoId,
    required this.data,
    required this.litros,
    required this.valorPago,
    required this.km,
    required this.combustivel,
    this.obs,
  });

  double get consumo => km / litros;

  Map<String, dynamic> toMap() {
    return {
      'veiculoId': veiculoId,
      'data': data.toIso8601String(),
      'litros': litros,
      'valorPago': valorPago,
      'km': km,
      'combustivel': combustivel,
      'obs': obs,
    };
  }

  factory Abastecimento.fromMap(String id, Map<String, dynamic> map) {
    return Abastecimento(
      id: id,
      veiculoId: map['veiculoId'],
      data: DateTime.parse(map['data']),
      litros: map['litros'],
      valorPago: map['valorPago'],
      km: map['km'],
      combustivel: map['combustivel'],
      obs: map['obs'],
    );
  }
}
