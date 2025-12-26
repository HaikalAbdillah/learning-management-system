import '../models/user.dart';

class UserRepository {
  static User? currentUser;

  static Map<String, dynamic> user = {
    'name': 'Haikal Abdillah',
    'email': 'mahasiswa@kampus.ac.id',
    'phone': '+62 812 3456 7890',
    'address': 'Jl. Telekomunikasi No. 1',
    'role': 'Mahasiswa',
    'nim': '1301194000',
    'jurusan': 'S1 Informatika',
    'angkatan': '2019',
  };
}
