import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool agreeLocation = false;

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
                    "إنشاء حساب",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 40),

                  // الاسم
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "الاسم الكامل",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v) => v!.isEmpty ? "هذا الحقل مطلوب" : null,
                  ),
                  const SizedBox(height: 15),

                  // الهاتف
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "رقم الهاتف",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (v) => v!.isEmpty ? "هذا الحقل مطلوب" : null,
                  ),
                  const SizedBox(height: 15),

                  // العنوان
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: "العنوان",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (v) => v!.isEmpty ? "هذا الحقل مطلوب" : null,
                  ),
                  const SizedBox(height: 15),

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
                  const SizedBox(height: 15),

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
                  const SizedBox(height: 15),

                  // الموافقة على مشاركة الموقع
                  Row(
                    children: [
                      Checkbox(
                        value: agreeLocation,
                        onChanged: (v) {
                          setState(() {
                            agreeLocation = v!;
                          });
                        },
                      ),
                      const Expanded(child: Text("موافقة على الشروط")),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // زر إنشاء الحساب
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (!agreeLocation) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("يجب الموافقة على الشروط")),
                          );
                          return;
                        }
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    child: const Text("إنشاء حساب", style: TextStyle(fontSize: 18,color: Colors.white)),
                  ),
                  const SizedBox(height: 15),

                  // الانتقال إلى تسجيل الدخول
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text("لديك حساب بالفعل؟ تسجيل الدخول"),
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
