import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/refueling_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../modelos/vehicle.dart';
import '../../modelos/refueling.dart';

class RefuelingScreen extends StatefulWidget {
  const RefuelingScreen({super.key});

  @override
  State<RefuelingScreen> createState() => _RefuelingScreenState();
}

class _RefuelingScreenState extends State<RefuelingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _litrosController = TextEditingController();
  final _valorController = TextEditingController();
  final _kmController = TextEditingController();
  final _observacaoController = TextEditingController();
  
  Vehicle? _selectedVehicle;
  DateTime _selectedDate = DateTime.now();

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
      appBar: AppBar(
        title: const Text('Registrar Abastecimento'),
      ),
      body: Consumer<VehicleProvider>(
        builder: (context, vehicleProvider, child) {
          if (vehicleProvider.vehicles.isEmpty) {
            return const Center(
              child: Text('Nenhum veículo cadastrado. Cadastre um veículo primeiro.'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<Vehicle>(
                    initialValue: _selectedVehicle,
                    decoration: const InputDecoration(
                      labelText: 'Veículo',
                      border: OutlineInputBorder(),
                    ),
                    items: vehicleProvider.vehicles.map((vehicle) {
                      return DropdownMenuItem(
                        value: vehicle,
                        child: Text('${vehicle.marca} ${vehicle.modelo} - ${vehicle.placa}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVehicle = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) return 'Selecione um veículo';
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _litrosController,
                    decoration: const InputDecoration(
                      labelText: 'Litros',
                      border: OutlineInputBorder(),
                      suffixText: 'L',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Campo obrigatório';
                      if (double.tryParse(value) == null) return 'Digite um número válido';
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _valorController,
                    decoration: const InputDecoration(
                      labelText: 'Valor Pago',
                      border: OutlineInputBorder(),
                      prefixText: 'R\$ ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Campo obrigatório';
                      if (double.tryParse(value) == null) return 'Digite um número válido';
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _kmController,
                    decoration: const InputDecoration(
                      labelText: 'Quilometragem',
                      border: OutlineInputBorder(),
                      suffixText: 'km',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Campo obrigatório';
                      if (double.tryParse(value) == null) return 'Digite um número válido';
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _observacaoController,
                    decoration: const InputDecoration(
                      labelText: 'Observações (opcional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  ListTile(
                    title: Text('Data: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                        });
                      }
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveRefueling,
                      child: const Text('Salvar Abastecimento'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveRefueling() async {
    if (!_formKey.currentState!.validate() || _selectedVehicle == null) {
      return;
    }

    final litros = double.parse(_litrosController.text);
    final valorPago = double.parse(_valorController.text);
    final km = double.parse(_kmController.text);
    
    // Calcular consumo (km/L)
    final consumo = litros > 0 ? km / litros : 0.0;

    final refueling = Refueling(
      id: '',
      veiculoId: _selectedVehicle!.id,
      data: _selectedDate,
      litros: litros,
      valorPago: valorPago,
      km: km,
      consumo: consumo,
      tipoCombustivel: _selectedVehicle!.tipoCombustivel,
      observacao: _observacaoController.text,
    );

    try {
      await context.read<RefuelingProvider>().addRefueling(refueling);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Abastecimento salvo com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _litrosController.dispose();
    _valorController.dispose();
    _kmController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }
}
