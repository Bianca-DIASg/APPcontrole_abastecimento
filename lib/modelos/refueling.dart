class Refueling {
  final String id;
  final String veiculoId;
  final DateTime data;
  final double litros;
  final double valorPago;
  final double km;
  final double consumo;
  final String tipoCombustivel;
  final String observacao;

  Refueling({
    required this.id,
    required this.veiculoId,
    required this.data,
    required this.litros,
    required this.valorPago,
    required this.km,
    required this.consumo,
    required this.tipoCombustivel,
    required this.observacao,
  });

  Map<String, dynamic> toMap() {
    return {
      "veiculoId": veiculoId,
      "data": data.toIso8601String(),
      "litros": litros,
      "valorPago": valorPago,
      "km": km,
      "consumo": consumo,
      "tipoCombustivel": tipoCombustivel,
      "observacao": observacao,
    };
  }

  factory Refueling.fromMap(String id, Map<String, dynamic> map) {
    return Refueling(
      id: id,
      veiculoId: map["veiculoId"],
      data: DateTime.parse(map["data"]),
      litros: map["litros"],
      valorPago: map["valorPago"],
      km: map["km"],
      consumo: map["consumo"],
      tipoCombustivel: map["tipoCombustivel"],
      observacao: map["observacao"],
    );
  }
}
