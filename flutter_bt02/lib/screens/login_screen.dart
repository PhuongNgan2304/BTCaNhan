import 'dart:convert' show jsonDecode;
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool isLoading = false;

  void handleLogin() async {
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showSnack('Vui lòng nhập đầy đủ email và mật khẩu');
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await AuthService.login(email, password);
      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final token = data['token'];
        final role = data['user']['role'];

        // Lưu JWT vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        if (role == 'admin') {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          showSnack('Bạn không phải là admin');
        }
      } else {
        showSnack(data['message'] ?? 'Đăng nhập thất bại');
      }
    } catch (e) {
      showSnack('Có lỗi xảy ra khi đăng nhập');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Login')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
        TextField(controller: passwordCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
        ElevatedButton(onPressed: handleLogin, child: const Text('Login')),
        TextButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: const Text('Register')),
        TextButton(onPressed: () => Navigator.pushNamed(context, '/forgot-password'), child: const Text('Forgot Password?')),
      ]),
    ),
  );
}
