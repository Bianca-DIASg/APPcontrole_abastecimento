import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/vehicles_screen.dart';
import '../screens/refueling/refueling_screen.dart';
import '../screens/refueling/refueling_history_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF89CFF0);

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: primary),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.directions_car_rounded,
                    size: 60, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "Controle de Abastecimento",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                )
              ],
            ),
          ),

          _item(context, Icons.directions_car, "Meus Veículos", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VehiclesScreen()),
            );
          }),

          _item(context, Icons.local_gas_station, "Registrar Abastecimento", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RefuelingScreen()),
            );
          }),

          _item(context, Icons.history, "Histórico de Abastecimentos", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RefuelingHistoryScreen()),
            );
          }),

          const Spacer(),

          _item(context, Icons.logout, "Sair", () {
            context.read<AuthProvider>().logout();
            Navigator.pushReplacementNamed(context, "/");
          }),
        ],
      ),
    );
  }

  Widget _item(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
