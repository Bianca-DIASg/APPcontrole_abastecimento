import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final senha = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF89CFF0);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                Icon(Icons.local_gas_station_rounded,
                    size: 90, color: primary),
                const SizedBox(height: 20),
                Text("Controle de Abastecimento",
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 30),

                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: senha,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: loading ? null : () async {
                      setState(() => loading = true);

                      final ok = await context
                          .read<AuthProvider>()
                          .login(email.text.trim(), senha.text.trim());

                      setState(() => loading = false);

                      if (ok) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("E-mail ou senha inválidos!")),
                        );
                      }
                    },
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text("Entrar"),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text("Criar conta"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
