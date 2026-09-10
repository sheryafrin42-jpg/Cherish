import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  
  XFile? _pickedImage; // Menyimpan file foto yang dipilih
  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk memilih foto dari Galeri
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  void _submitData() {
    final title = _titleController.text;
    final price = double.tryParse(_priceController.text);

    if (title.isEmpty || price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi nama produk dan harga dengan benar!')),
      );
      return;
    }

    // Gunakan path gambar yang dipilih atau default jika belum ada
    final imageUrl = _pickedImage != null ? _pickedImage!.path : 'assets/images/baju.jpg';

    Provider.of<CartProvider>(context, listen: false).addProduct(
      Product(
        id: DateTime.now().toString(),
        title: title,
        price: price,
        imageUrl: imageUrl,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF8DA1),
        title: const Text('Tambah Produk Baru', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Harga (Rp)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 25),
            
            // Klik kotak ini untuk memilih/upload foto
            GestureDetector(
              onTap: _pickImage,
              child: Column(
                children: [
                  const Text(
                    'Klik kotak di bawah untuk upload foto:',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 164,
                    height: 142,
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFF8DA1), width: 1.5),
                    ),
                    child: _pickedImage == null
                        ? const Center(
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              color: Color(0xFFFF8DA1),
                              size: 40,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: kIsWeb
                                ? Image.network(_pickedImage!.path, fit: BoxFit.cover)
                                : Image.file(File(_pickedImage!.path), fit: BoxFit.cover),
                          ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8DA1),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Simpan Produk',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}