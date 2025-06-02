import '../../../core/database/database_helper.dart';
import '../models/user.dart';

class LoginController {
  final DatabaseHelper _db = DatabaseHelper();

  Future<User?> login(String id, String pw) async {
    final map = await _db.validateUser(id, pw);
    if (map != null) return User.fromMap(map);
    return null;
  }

  Future<void> signUp(String id, String pw, String role) async {
    await _db.insertUser(id, pw, role);
  }

}
