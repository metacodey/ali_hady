import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "تسجيل الدخول",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 60),

                  // البريد الإلكتروني
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "البريد الإلكتروني",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (v) => v!.isEmpty ? "هذا الحقل مطلوب" : null,
                  ),
                  const SizedBox(height: 20),

                  // كلمة المرور
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "كلمة المرور",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (v) => v!.isEmpty ? "هذا الحقل مطلوب" : null,
                  ),
                  const SizedBox(height: 30),

                  // زر تسجيل الدخول
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    child: const Text("تسجيل الدخول", style: TextStyle(fontSize: 18,color: Colors.white)),
                  ),
                  const SizedBox(height: 15),

                  // الانتقال لإنشاء حساب
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
                    child: const Text("إنشاء حساب جديد"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
