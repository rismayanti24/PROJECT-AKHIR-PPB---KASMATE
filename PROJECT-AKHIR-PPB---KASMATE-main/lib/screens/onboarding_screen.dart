import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onSelesai});

  final VoidCallback onSelesai;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _jumlahSlide = 3;

  final _pageController = PageController();
  int _halamanAktif = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _lanjut() {
    if (_halamanAktif == _jumlahSlide - 1) {
      widget.onSelesai();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final slides = [
      (
        ikon: Icons.receipt_long_outlined,
        judul: 'Split bill jadi mudah',
        deskripsi:
            'Bagi tagihan bersama teman dengan jelas. Semua orang tahu bagian yang perlu dibayar.',
      ),
      (
        ikon: Icons.home_work_outlined,
        judul: 'Kelola kas kos',
        deskripsi:
            'Catat pemasukan dan pengeluaran kas kos agar keuangan bersama tetap tertata.',
      ),
      (
        ikon: Icons.chat_outlined,
        judul: 'Ingatkan lewat WhatsApp',
        deskripsi:
            'Kirim pengingat tagihan melalui WhatsApp supaya teman-teman tidak lupa membayar.',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.onSelesai,
                  child: const Text('Lewati'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _jumlahSlide,
                  onPageChanged: (halaman) {
                    setState(() {
                      _halamanAktif = halaman;
                    });
                  },
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: SizedBox(
                            width: 184,
                            height: 184,
                            child: Icon(
                              slide.ikon,
                              size: 88,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slide.judul,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.deskripsi,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_jumlahSlide, (index) {
                  final isAktif = index == _halamanAktif;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isAktif ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isAktif
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _lanjut,
                  child: Text(
                    _halamanAktif == _jumlahSlide - 1 ? 'Mulai' : 'Lanjut',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
