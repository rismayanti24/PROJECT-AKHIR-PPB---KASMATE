import 'package:flutter/material.dart';
import '../data/kas_store.dart';

class BuatTagihanScreen extends StatefulWidget {
  const BuatTagihanScreen({super.key});

  @override
  State<BuatTagihanScreen> createState() => _BuatTagihanScreenState();
}

class _BuatTagihanScreenState extends State<BuatTagihanScreen> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _namaItemController = TextEditingController();
  final TextEditingController _hargaItemController = TextEditingController();

  int _sumberDanaIndex = 0;
  int _bagiKeIndex = 0;

  final List<ItemBelanja> _items = [];
  final Set<String> _anggotaTerpilih = {};

  static const Color _primaryGreen = Color(0xFF074E3B);

  @override
  void initState() {
    super.initState();
    for (final a in kasStore.grupAktif.anggota) {
      _anggotaTerpilih.add(a.id);
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _namaItemController.dispose();
    _hargaItemController.dispose();
    super.dispose();
  }

  int _parseHarga(String text) {
    return int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  List<ItemBelanja> get _semuaItemAktif {
    final list = List<ItemBelanja>.from(_items);
    final namaDraft = _namaItemController.text.trim();
    final hargaDraft = _parseHarga(_hargaItemController.text);
    if (hargaDraft > 0) {
      list.add(
        ItemBelanja(
          id: 'draft',
          nama: namaDraft.isEmpty
              ? (_judulController.text.trim().isEmpty
                  ? 'Pengeluaran'
                  : _judulController.text.trim())
              : namaDraft,
          harga: hargaDraft,
        ),
      );
    }
    return list;
  }

  int get _subtotal =>
      _semuaItemAktif.fold<int>(0, (sum, item) => sum + item.harga);
  int get _pajak => (_subtotal * 0.1).round();
  int get _total => _subtotal + _pajak;

  void _tambahItemKeDaftar() {
    final nama = _namaItemController.text.trim();
    final harga = _parseHarga(_hargaItemController.text);

    if (nama.isEmpty || harga <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi nama item dan nominal harga terlebih dahulu'),
        ),
      );
      return;
    }

    setState(() {
      _items.add(
        ItemBelanja(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nama: nama,
          harga: harga,
        ),
      );
      _namaItemController.clear();
      _hargaItemController.clear();
    });
  }

  void _simpanTagihan() {
    final daftarFinal = _semuaItemAktif;

    if (daftarFinal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan minimal 1 item pengeluaran dan nominalnya'),
        ),
      );
      return;
    }

    if (_bagiKeIndex == 1 && _anggotaTerpilih.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal 1 anggota yang ditagih'),
        ),
      );
      return;
    }

    final judulFinal = _judulController.text.trim().isEmpty
        ? daftarFinal.first.nama
        : _judulController.text.trim();

    final targetIds = _bagiKeIndex == 0
        ? kasStore.grupAktif.anggota.map((e) => e.id).toList()
        : _anggotaTerpilih.toList();

    kasStore.tambahTagihan(
      judul: judulFinal,
      sumberDana: _sumberDanaIndex == 0 ? 'Kas grup' : 'Dana pribadi',
      items: daftarFinal,
      idAnggotaDitagih: targetIds,
    );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tagihan "$judulFinal" (${formatRupiah(_total)}) berhasil ditambahkan!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final semuaAnggota = kasStore.grupAktif.anggota;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF111827)),
        title: const Text(
          'Catat pengeluaran',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Judul pengeluaran',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _judulController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Contoh: Belanja dapur, Galon, Token listrik',
                  hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: _primaryGreen, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sumber dana',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildSelectableChip(
                      label: 'Kas grup',
                      isSelected: _sumberDanaIndex == 0,
                      onTap: () => setState(() => _sumberDanaIndex = 0),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSelectableChip(
                      label: 'Dana pribadi',
                      isSelected: _sumberDanaIndex == 1,
                      onTap: () => setState(() => _sumberDanaIndex = 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tambah rincian pengeluaran',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _namaItemController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: 'Nama barang / keperluan',
                        hintText: 'Contoh: Air galon 2x',
                        filled: true,
                        fillColor: const Color(0xFFFAFAFA),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _hargaItemController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              labelText: 'Nominal (Rp)',
                              hintText: '20000',
                              prefixText: 'Rp ',
                              filled: true,
                              fillColor: const Color(0xFFFAFAFA),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: _tambahItemKeDaftar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFECFDF5),
                            foregroundColor: _primaryGreen,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: _primaryGreen),
                            ),
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text(
                            'Tambah',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_semuaItemAktif.length} item pengeluaran',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF15803D),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_items.isEmpty && _semuaItemAktif.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Belum ada item. Ketik barang dan nominal di atas.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    ..._items.map(
                      (item) => Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.nama,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              Text(
                                formatRupiah(item.harga),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  setState(() => _items.remove(item));
                                },
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: Color(0xFFB91C1C),
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Color(0xFFE5E7EB), height: 20),
                        ],
                      ),
                    ),
                    if (_parseHarga(_hargaItemController.text) > 0) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _namaItemController.text.trim().isEmpty
                                  ? (_judulController.text.trim().isEmpty
                                      ? 'Pengeluaran (draft)'
                                      : '${_judulController.text.trim()} (draft)')
                                  : '${_namaItemController.text.trim()} (draft)',
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                          ),
                          Text(
                            formatRupiah(
                              _parseHarga(_hargaItemController.text),
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFFE5E7EB), height: 20),
                    ],
                    _buildReceiptRow(
                      'Pajak 10%',
                      formatRupiah(_pajak),
                      isMuted: true,
                    ),
                    const Divider(color: Color(0xFFE5E7EB), height: 20),
                    _buildReceiptRow(
                      'Total',
                      formatRupiah(_total),
                      isBold: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Bagi ke',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildSelectableChip(
                      label: 'Rata (${semuaAnggota.length} orang)',
                      isSelected: _bagiKeIndex == 0,
                      onTap: () => setState(() => _bagiKeIndex = 0),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSelectableChip(
                      label: 'Pilih anggota',
                      isSelected: _bagiKeIndex == 1,
                      onTap: () => setState(() => _bagiKeIndex = 1),
                    ),
                  ),
                ],
              ),
              if (_bagiKeIndex == 1) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: semuaAnggota.map((anggota) {
                    final dipilih = _anggotaTerpilih.contains(anggota.id);
                    return FilterChip(
                      label: Text(anggota.nama),
                      selected: dipilih,
                      selectedColor: const Color(0xFFDCFCE7),
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _anggotaTerpilih.add(anggota.id);
                          } else {
                            _anggotaTerpilih.remove(anggota.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: ElevatedButton(
                  onPressed: _simpanTagihan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Simpan tagihan',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _primaryGreen : const Color(0xFFE5E7EB),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? _primaryGreen : const Color(0xFF111827),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(
    String name,
    String price, {
    bool isBold = false,
    bool isMuted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isMuted ? const Color(0xFF6B7280) : const Color(0xFF111827),
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isMuted ? const Color(0xFF6B7280) : const Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}
