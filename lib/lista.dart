import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListaScreen extends StatelessWidget {
  const ListaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('productos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los productos'));
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index].data() as Map<String, dynamic>;

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: product['url_imagen'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  title: Text(product['nombre']),
                  subtitle: Text('Categoría: ${product['categoria']}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('\$${product['precio']}'),
                      Text('Stock: ${product['stock']}'),
                    ],
                  ),
                  onTap: () {
                    // Mostrar el diálogo con toda la información del producto
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(product['nombre']),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: product['url_imagen'],
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                SizedBox(height: 15),
                                Text('Categoría: ${product['categoria']}'),
                                SizedBox(height: 10),
                                Text('Precio: \$${product['precio']}'),
                                SizedBox(height: 10),
                                Text('Stock: ${product['stock']}'),
                                SizedBox(height: 10),
                                Text('ID Producto: ${product['id_producto']}'),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cerrar'),
                            ),
                            // Botón Editar
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _showEditDialog(context, product);
                              },
                              child: const Text('Editar'),
                            ),
                            // Botón Eliminar
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _deleteProduct(context, product['id_producto']);
                              },
                              child: const Text('Eliminar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Mostrar el diálogo para editar un producto
  void _showEditDialog(BuildContext context, Map<String, dynamic> product) {
    final nombreController = TextEditingController(text: product['nombre']);
    final precioController =
        TextEditingController(text: product['precio'].toString());
    final stockController =
        TextEditingController(text: product['stock'].toString());
    final categoriaController =
        TextEditingController(text: product['categoria']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Producto'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: precioController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: categoriaController,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Verificar que los valores no estén vacíos
                if (nombreController.text.isEmpty ||
                    precioController.text.isEmpty ||
                    stockController.text.isEmpty ||
                    categoriaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor complete todos los campos')),
                  );
                  return;
                }

                // Guardar cambios en Firestore
                await FirebaseFirestore.instance
                    .collection('productos')
                    .doc(product['id_producto'])
                    .update({
                  'nombre': nombreController.text,
                  'precio': double.parse(precioController.text),
                  'stock': int.parse(stockController.text),
                  'categoria': categoriaController.text,
                });

                // Actualizar la lista
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Producto actualizado')),
                );

                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Eliminar un producto de Firestore
  Future<void> _deleteProduct(BuildContext context, String productId) async {
    // Confirmar eliminación
    bool confirm = await _showDeleteDialog(context);
    if (confirm) {
      await FirebaseFirestore.instance
          .collection('productos')
          .doc(productId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto eliminado')),
      );
    }
  }

  // Mostrar cuadro de confirmación para eliminar
  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmación'),
              content: const Text('¿Estás seguro de eliminar este producto?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Eliminar'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
