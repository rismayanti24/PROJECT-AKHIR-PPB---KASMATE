import 'package:flutter/material.dart';
import '../utils/format.dart';

class ItemStrukCard extends StatelessWidget {
  final String namaBarang;
  final int harga;

  const ItemStrukCard({
    super.key,
    required this.namaBarang,
    required this.harga,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            namaBarang,
            style: const TextStyle(fontSize: 14),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(
                      (constraints.constrainWidth() / 6).floor(),
                      (index) => const SizedBox(
                        width: 3,
                        height: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Text(
            formatRupiah(harga),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
