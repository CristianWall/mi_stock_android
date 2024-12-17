import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();
  final _categoriaController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Función para generar un ID único de 6 dígitos
  String _generateProductId() {
    final random = Random();
    return (random.nextInt(900000) + 100000).toString(); // 6 dígitos aleatorios
  }

  Future<void> _guardarProducto() async {
    if (_nombreController.text.isEmpty ||
        _precioController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _categoriaController.text.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    // Subir imagen a Firebase Storage
    try {
      final imageRef = FirebaseStorage.instance.ref().child('productos').child(
          '${_generateProductId()}.jpg'); // Usamos el ID generado como nombre del archivo
      await imageRef.putFile(_image!);
      String imageUrl = await imageRef.getDownloadURL();

      // Generar ID único de producto
      String idProducto = _generateProductId();

      // Guardar información del producto en Firestore
      await FirebaseFirestore.instance
          .collection('productos')
          .doc(idProducto)
          .set({
        'nombre': _nombreController.text,
        'precio': double.parse(_precioController.text),
        'stock': int.parse(_stockController.text),
        'categoria': _categoriaController.text,
        'url_imagen': imageUrl,
        'id_producto': idProducto, // Guardar el ID del producto
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto registrado con éxito')),
      );

      // Limpiar campos
      _nombreController.clear();
      _precioController.clear();
      _stockController.clear();
      _categoriaController.clear();
      setState(() {
        _image = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar el producto: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Producto',
              ),
            ),
            TextField(
              controller: _precioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio del Producto',
              ),
            ),
            TextField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad en Stock',
              ),
            ),
            TextField(
              controller: _categoriaController,
              decoration: const InputDecoration(
                labelText: 'Categoría',
              ),
            ),
            const SizedBox(height: 10),
            _image == null
                ? const Text('No se ha seleccionado imagen')
                : Image.file(_image!, width: 150, height: 150),
            TextButton(
              onPressed: _pickImage,
              child: const Text('Seleccionar Imagen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarProducto,
              child: const Text('Registrar Producto'),
            ),
          ],
        ),
      ),
    );
  }
}
