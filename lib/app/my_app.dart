import 'package:flutter/material.dart';
import 'shopping_mall_app.dart';
import '../feature/user/controllers/login_controller.dart';
import '../feature/user/models/user.dart';
import '../feature/user/views/login_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  final LoginController _loginController = LoginController();

  void _handleLogin(String id, String pw) async {
    // 테스트용 admin 계정
    if (id == 'admin' && pw == '1234') {
      setState(() => _isLoggedIn = true);
      return;
    }

    final User? user = await _loginController.login(id, pw);

    if (user != null && user.isApproved == 1) {
      setState(() => _isLoggedIn = true);
    } else {
      _showLoginFailedDialog();
    }
  }

  void _showLoginFailedDialog() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text('로그인 실패'),
        content: Text('아이디 또는 비밀번호가 틀렸거나, 관리자의 승인이 필요합니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    setState(() => _isLoggedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 쇼핑몰',
      navigatorKey: navigatorKey,
      home: _isLoggedIn
          ? ShoppingMallApp(onLogout: _handleLogout)
          : LoginScreen(onLogin: _handleLogin),
    );
  }
}
