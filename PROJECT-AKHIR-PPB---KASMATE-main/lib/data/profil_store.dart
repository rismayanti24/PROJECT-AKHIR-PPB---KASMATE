import 'package:flutter/foundation.dart';

import '../models/pengguna.dart';
import 'dummy.dart';

final ValueNotifier<Pengguna> profilNotifier =
    ValueNotifier<Pengguna>(dummyPengguna.first);

void simpanProfil(Pengguna profil) {
  profilNotifier.value = profil;
}
