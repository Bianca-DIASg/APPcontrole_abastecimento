import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';
import '../modelos/vehicle.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleProvider>().loadVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Veículos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addVehicleDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<VehicleProvider>(
        builder: (context, vehicleProvider, child) {
          if (vehicleProvider.vehicles.isEmpty) {
            return const Center(
              child: Text('Nenhum veículo cadastrado.'),
            );
          }

          return ListView.builder(
            itemCount: vehicleProvider.vehicles.length,
            itemBuilder: (_, i) {
              final vehicle = vehicleProvider.vehicles[i];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('${vehicle.marca} ${vehicle.modelo}'),
                  subtitle: Text(
                      'Placa: ${vehicle.placa}\nAno: ${vehicle.ano} - ${vehicle.tipoCombustivel}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(vehicle.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(String vehicleId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir este veículo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<VehicleProvider>().deleteVehicle(vehicleId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Veículo excluído')),
              );
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _addVehicleDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final modeloController = TextEditingController();
    final marcaController = TextEditingController();
    final placaController = TextEditingController();
    final anoController = TextEditingController();
    String tipoCombustivel = 'Gasolina';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cadastrar Veículo'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: modeloController,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                  validator: (v) => v!.isEmpty ? 'Digite o modelo' : null,
                ),
                TextFormField(
                  controller: marcaController,
                  decoration: const InputDecoration(labelText: 'Marca'),
                  validator: (v) => v!.isEmpty ? 'Digite a marca' : null,
                ),
                TextFormField(
                  controller: placaController,
                  decoration: const InputDecoration(labelText: 'Placa'),
                  validator: (v) => v!.isEmpty ? 'Digite a placa' : null,
                ),
                TextFormField(
                  controller: anoController,
                  decoration: const InputDecoration(labelText: 'Ano'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Digite o ano' : null,
                ),
                const SizedBox(height: 16),
                StatefulBuilder(
                  builder: (context, setState) {
                    return DropdownButtonFormField<String>(
                      initialValue: tipoCombustivel,
                      decoration: const InputDecoration(labelText: 'Tipo de Combustível'),
                      items: const [
                        DropdownMenuItem(value: 'Gasolina', child: Text('Gasolina')),
                        DropdownMenuItem(value: 'Álcool', child: Text('Álcool')),
                        DropdownMenuItem(value: 'Diesel', child: Text('Diesel')),
                        DropdownMenuItem(value: 'GNV', child: Text('GNV')),
                        DropdownMenuItem(value: 'Flex', child: Text('Flex')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          tipoCombustivel = value!;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final vehicle = Vehicle(
                  id: '',
                  modelo: modeloController.text,
                  marca: marcaController.text,
                  placa: placaController.text,
                  ano: int.tryParse(anoController.text) ?? 0,
                  tipoCombustivel: tipoCombustivel,
                );

                try {
                  await context.read<VehicleProvider>().addVehicle(vehicle);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veículo cadastrado com sucesso!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao cadastrar: $e')),
                  );
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
