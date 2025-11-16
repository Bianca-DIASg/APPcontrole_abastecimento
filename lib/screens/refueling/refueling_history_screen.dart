import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/refueling_provider.dart';
import '../../providers/vehicle_provider.dart';

class RefuelingHistoryScreen extends StatefulWidget {
  const RefuelingHistoryScreen({super.key});

  @override
  State<RefuelingHistoryScreen> createState() => _RefuelingHistoryScreenState();
}

class _RefuelingHistoryScreenState extends State<RefuelingHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RefuelingProvider>().loadRefuelings();
      context.read<VehicleProvider>().loadVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Abastecimentos'),
      ),
      body: Consumer2<RefuelingProvider, VehicleProvider>(
        builder: (context, refuelingProvider, vehicleProvider, child) {
          if (refuelingProvider.refuelings.isEmpty) {
            return const Center(
              child: Text('Nenhum abastecimento registrado.'),
            );
          }

          return ListView.builder(
            itemCount: refuelingProvider.refuelings.length,
            itemBuilder: (context, index) {
              final refueling = refuelingProvider.refuelings[index];
              final vehicle = vehicleProvider.vehicles
                  .firstWhere((v) => v.id == refueling.veiculoId,
                      orElse: () => vehicleProvider.vehicles.first);

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('${vehicle.marca} ${vehicle.modelo}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data: ${refueling.data.day}/${refueling.data.month}/${refueling.data.year}'),
                      Text('Litros: ${refueling.litros.toStringAsFixed(2)}L'),
                      Text('Valor: R\$ ${refueling.valorPago.toStringAsFixed(2)}'),
                      Text('Quilometragem: ${refueling.km.toStringAsFixed(0)} km'),
                      Text('Consumo: ${refueling.consumo.toStringAsFixed(2)} km/L'),
                      if (refueling.observacao.isNotEmpty)
                        Text('Obs: ${refueling.observacao}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(refueling.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(String refuelingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir este abastecimento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<RefuelingProvider>().deleteRefueling(refuelingId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Abastecimento excluído')),
              );
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
