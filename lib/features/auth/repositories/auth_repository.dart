import 'package:hive/hive.dart';
import 'package:todo_mvvm_app/core/constant.dart';
import 'package:todo_mvvm_app/features/auth/models/user_model.dart';

class AuthRepository {
  Future<Box> _openUsersBox() async {
    return await Hive.openBox(Constants.usersBox);
  }

  Future<bool> register(User user) async {
    final box = await _openUsersBox();
    if (box.containsKey(user.email)) {
      return false;
    }
    await box.put(user.email, user);
    return true;
  }

  Future<User?> getUser(String email) async {
    final box = await _openUsersBox();
    return box.get(email);
  }
}
