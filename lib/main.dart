import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mi_stock_android/lista.dart';
import 'package:mi_stock_android/registro.dart';
import 'package:mi_stock_android/venta.dart';

void main() async {
  // Inicializar Firebase antes de que se ejecute la aplicación
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Lateral'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú Principal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Registro'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegistroScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Lista'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListaScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Venta'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VentaScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Selecciona una opción del menú'),
      ),
    );
  }
}
