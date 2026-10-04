String formatRupiah(int number) {
  String result = number.toString();
  String formatted = '';
  int count = 0;
  for (int i = result.length - 1; i >= 0; i--) {
    formatted = result[i] + formatted;
    count++;
    if (count % 3 == 0 && i != 0) {
      formatted = '.$formatted';
    }
  }
  return 'Rp $formatted';
}
