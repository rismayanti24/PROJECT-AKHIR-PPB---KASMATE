import 'package:flutter/material.dart';

import '../data/profil_store.dart';
import '../models/pengguna.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _noWaController;
  late final TextEditingController _bankController;
  late final TextEditingController _noRekeningController;

  @override
  void initState() {
    super.initState();
    final profil = profilNotifier.value;
    _namaController = TextEditingController(text: profil.nama);
    _noWaController = TextEditingController(text: profil.noWa);
    _bankController = TextEditingController(text: profil.bank);
    _noRekeningController = TextEditingController(text: profil.noRekening);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _noWaController.dispose();
    _bankController.dispose();
    _noRekeningController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final profilLama = profilNotifier.value;
    simpanProfil(
      Pengguna(
        id: profilLama.id,
        nama: _namaController.text.trim(),
        noWa: _noWaController.text.trim(),
        bank: _bankController.text.trim(),
        noRekening: _noRekeningController.text.trim(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil disimpan')),
    );
  }

  String? _validasiAngka(String? value, {required bool wajib}) {
    final teks = value?.trim() ?? '';
    if (teks.isEmpty) {
      return wajib ? 'Field ini wajib diisi' : null;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(teks)) {
      return 'Hanya boleh berisi angka';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Nama wajib diisi'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noWaController,
              decoration: const InputDecoration(
                labelText: 'No WA',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) => _validasiAngka(value, wajib: false),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bankController,
              decoration: const InputDecoration(
                labelText: 'Bank',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noRekeningController,
              decoration: const InputDecoration(
                labelText: 'No Rekening',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) => _validasiAngka(value, wajib: true),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _simpan,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
