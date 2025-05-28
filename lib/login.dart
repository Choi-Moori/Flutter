import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class LoginScreen extends StatefulWidget {
  final void Function(String id, String pw) onLogin;
  const LoginScreen({required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final TextEditingController _signUpIdController = TextEditingController();
  final TextEditingController _signUpPwController = TextEditingController();
  final TextEditingController _signUpPwConfirmController = TextEditingController();

  bool _passwordsMatch = true;
  String _selectedRole = 'guest';
  bool _isAdmin = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _signUpIdController.dispose();
    _signUpPwController.dispose();
    _signUpPwConfirmController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _triggerLogin() {
    final id = _idController.text;
    final pw = _pwController.text;
    widget.onLogin(id, pw);
  }

  void _handleSignUp() async {
    setState(() {
      _passwordsMatch =
          _signUpPwController.text == _signUpPwConfirmController.text;
    });

    if (!_passwordsMatch) return;

    try {
      await DatabaseHelper().insertUser(
        _signUpIdController.text,
        _signUpPwController.text,
        _selectedRole,
      );

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('회원가입 성공'),
          content: Text('ID: ${_signUpIdController.text}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('확인'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('회원가입 실패'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('인증'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '로그인'),
            Tab(text: '회원가입'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 로그인 탭
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '로그인 정보를 입력하세요',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: '아이디'),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _pwController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: '비밀번호'),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _triggerLogin(),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _triggerLogin,
                    child: Text('로그인'),
                  ),
                ),
              ],
            ),
          ),

          // 회원가입 탭
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '회원가입 정보를 입력하세요',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _signUpIdController,
                    decoration: InputDecoration(labelText: '아이디'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _signUpPwController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: '비밀번호'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _signUpPwConfirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: '비밀번호 확인',
                      errorText: _passwordsMatch ? null : '비밀번호가 일치하지 않습니다.',
                    ),
                  ),
                  CheckboxListTile(
                    title: Text('관리자 권한 요청'),
                    value: _isAdmin,
                    onChanged: (value) {
                      setState((){
                        _isAdmin = value!;
                        _selectedRole = _isAdmin ? 'admin' : 'guest';
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),  
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _handleSignUp,
                      child: Text('회원가입'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
