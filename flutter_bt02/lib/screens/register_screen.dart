import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final otpCtrl = TextEditingController();
  bool sentOtp = false;

  void handleRegister() async {
    final res = await AuthService.register(
      name: nameCtrl.text,
      email: emailCtrl.text,
      password: passwordCtrl.text,
      phone: phoneCtrl.text,
      otp: sentOtp ? otpCtrl.text : null,
    );
    final data = jsonDecode(res.body)['message'];
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));

    if (res.statusCode == 200 && !sentOtp) setState(() => sentOtp = true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Register')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
        TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
        TextField(controller: passwordCtrl, decoration: const InputDecoration(labelText: 'Password')),
        TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
        if (sentOtp) TextField(controller: otpCtrl, decoration: const InputDecoration(labelText: 'Enter OTP')),
        ElevatedButton(onPressed: handleRegister, child: Text(sentOtp ? 'Confirm OTP' : 'Send OTP')),
      ]),
    ),
  );
}
