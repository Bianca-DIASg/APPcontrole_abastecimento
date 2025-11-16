import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                Icon(Icons.person_add_rounded,
                    size: 90, color: primary),
                const SizedBox(height: 20),

                Text("Criar Conta",
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
                    onPressed: loading
                        ? null
                        : () async {
                            setState(() => loading = true);

                            final error = await context
                                .read<AuthProvider>()
                                .register(email.text.trim(),
                                    senha.text.trim());

                            setState(() => loading = false);

                            if (error == null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error)),
                              );
                            }
                          },
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text("Cadastrar"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
