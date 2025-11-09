import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Abastecimento',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String mensagem = '';

  Future<void> testarFirebase() async {
    String resultado = '';

    // Teste Firestore
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('teste').get();
      resultado +=
          '✅ Firestore OK! Docs encontrados: ${snapshot.docs.length}\n';
    } catch (e) {
      resultado += '❌ Firestore erro: $e\n';
    }

    // Teste Auth
    try {
      final user = FirebaseAuth.instance.currentUser;
      resultado += '✅ Firebase Auth OK! Usuário atual: $user\n';
    } catch (e) {
      resultado += '❌ Firebase Auth erro: $e\n';
    }

    setState(() {
      mensagem = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teste Firebase')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: testarFirebase,
              child: const Text('Testar Conexão Firebase'),
            ),
            const SizedBox(height: 20),
            Text(mensagem, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
