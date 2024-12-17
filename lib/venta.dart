import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VentaScreen extends StatefulWidget {
  const VentaScreen({super.key});

  @override
  State<VentaScreen> createState() => _VentaScreenState();
}

class _VentaScreenState extends State<VentaScreen> {
  final TextEditingController _idProductoController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();

  String _nombreProducto = '';
  double _precioProducto = 0.0;
  int _stockDisponible = 0;
  bool _productoEncontrado = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> buscarProducto() async {
    final idProducto = _idProductoController.text.trim();
    if (idProducto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un ID de producto.')),
      );
      return;
    }

    try {
      final productoDoc =
          await _firestore.collection('productos').doc(idProducto).get();
      if (productoDoc.exists) {
        final productoData = productoDoc.data();
        setState(() {
          _nombreProducto = productoData?['nombre'] ?? 'Sin nombre';
          _precioProducto = productoData?['precio']?.toDouble() ?? 0.0;
          _stockDisponible = productoData?['stock']?.toInt() ?? 0;
          _productoEncontrado = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('No se encontró un producto con ID: $idProducto')),
        );
        setState(() {
          _productoEncontrado = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar producto: $e')),
      );
    }
  }

  Future<void> realizarCompra() async {
    if (!_productoEncontrado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero busca un producto válido.')),
      );
      return;
    }

    final cantidadText = _cantidadController.text.trim();
    if (cantidadText.isEmpty || int.tryParse(cantidadText) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa una cantidad válida.')),
      );
      return;
    }

    final cantidadComprada = int.parse(cantidadText);
    if (cantidadComprada > _stockDisponible) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay suficiente stock disponible.')),
      );
      return;
    }

    try {
      final idProducto = _idProductoController.text.trim();
      final nuevoStock = _stockDisponible - cantidadComprada;

      await _firestore.collection('productos').doc(idProducto).update({
        'stock': nuevoStock,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Compra exitosa: $_nombreProducto\nCantidad: $cantidadComprada\nStock restante: $nuevoStock',
          ),
        ),
      );

      // Limpiar el formulario y resetear variables
      setState(() {
        _idProductoController.clear();
        _cantidadController.clear();
        _nombreProducto = '';
        _precioProducto = 0.0;
        _stockDisponible = 0;
        _productoEncontrado = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al realizar la compra: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Ventas'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _idProductoController,
              decoration: const InputDecoration(
                labelText: 'ID del Producto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: buscarProducto,
              child: const Text('Buscar Producto'),
            ),
            const SizedBox(height: 20),
            if (_productoEncontrado) ...[
              Text(
                'Nombre: $_nombreProducto',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Precio Unitario: \$${_precioProducto.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Stock Disponible: $_stockDisponible',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _cantidadController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad a Comprar',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: realizarCompra,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Realizar Compra'),
              ),
            ] else
              const Center(
                child: Text(
                  'No se ha encontrado el producto.\nBusca un ID válido.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
