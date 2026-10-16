import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'detail_tagihan_screen.dart';
import 'bayar_tagihan_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const DetailTagihanScreen(),
    const BayarTagihanScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: const Color(0xFF1976D2),
        shape: const CircleBorder(),
        onPressed: () {
          setState(() {
            _currentIndex = 1; // Pindah ke Detail/Tambah Tagihan
          });
        },
        child: const Icon(Icons.receipt_long, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: const Color(0xFF0D1B2A), // Warna biru gelap sesuai gambar
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: 60.0,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.dashboard_rounded,
                  color: _currentIndex == 0 ? Colors.white : Colors.white54,
                ),
                onPressed: () => setState(() => _currentIndex = 0),
              ),
              const SizedBox(width: 40), // Spasi untuk Floating Button di tengah
              IconButton(
                icon: Icon(
                  Icons.person_rounded,
                  color: _currentIndex == 2 ? Colors.white : Colors.white54,
                ),
                onPressed: () => setState(() => _currentIndex = 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}