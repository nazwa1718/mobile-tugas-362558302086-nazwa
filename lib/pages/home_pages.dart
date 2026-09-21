import 'package:flutter/material.dart';
import 'detail_pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kantin Kampus',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Gambar makanan dengan ukuran yang lebih proporsional (tinggi 170)
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                'https://images.unsplash.com/photo-1603133872878-684f208fb84b?auto=format&fit=crop&w=800&q=80',
                height:
                    170, // Ukuran disesuaikan agar lebih pas dan proporsional
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 170, // Menyesuaikan tinggi container error
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.fastfood,
                      size: 60, // Ukuran icon disesuaikan
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Nama makanan
            const Text(
              'Nasi Goreng',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Harga
            const Text(
              'Rp15.000',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 15),

            // Deskripsi
            const Text(
              'Nasi goreng dengan telur, ayam, dan sayuran.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 30),

            // Tombol lihat detail
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Lihat Detail',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}