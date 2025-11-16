class Vehicle {
  final String id;
  final String modelo;
  final String marca;
  final String placa;
  final int ano;
  final String tipoCombustivel;

  Vehicle({
    required this.id,
    required this.modelo,
    required this.marca,
    required this.placa,
    required this.ano,
    required this.tipoCombustivel,
  });

  Map<String, dynamic> toMap() {
    return {
      "modelo": modelo,
      "marca": marca,
      "placa": placa,
      "ano": ano,
      "tipoCombustivel": tipoCombustivel,
    };
  }

  factory Vehicle.fromMap(String id, Map<String, dynamic> map) {
    return Vehicle(
      id: id,
      modelo: map["modelo"],
      marca: map["marca"],
      placa: map["placa"],
      ano: map["ano"],
      tipoCombustivel: map["tipoCombustivel"],
    );
  }
}
