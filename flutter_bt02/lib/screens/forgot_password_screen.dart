import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailCtrl = TextEditingController();
  final otpCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  bool otpSent = false;

  void handleResetPassword() async {
    final res = await AuthService.forgotPassword(
      email: emailCtrl.text,
      otp: otpSent ? otpCtrl.text : null,
      newPassword: otpSent ? newPassCtrl.text : null,
      confirmPassword: otpSent ? confirmPassCtrl.text : null,
    );
    final data = jsonDecode(res.body)['message'];
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));

    if (res.statusCode == 200 && !otpSent) setState(() => otpSent = true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Forgot Password')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
        if (otpSent) ...[
          TextField(controller: otpCtrl, decoration: const InputDecoration(labelText: 'OTP')),
          TextField(controller: newPassCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'New Password')),
          TextField(controller: confirmPassCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm Password')),
        ],
        ElevatedButton(onPressed: handleResetPassword, child: Text(otpSent ? 'Confirm OTP' : 'Send OTP')),
      ]),
    ),
  );
}
