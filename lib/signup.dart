import 'package:flutter/material.dart';
import 'package:untitled/login.dart';
import 'package:untitled/ques_database';
import 'package:get/get.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  @override
  State<SignupPage> createState() => _SignupPageState();
}
 
class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  var usernameController= TextEditingController();
  var passwordController= TextEditingController();

final db= DBHelper();
  void _submit() {
   db.insertusers(usernameController.text, passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signing up...')),
     
      );
      Get.to(LoginPage());
    }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Colors.tealAccent),
                ),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Colors.tealAccent),
                ),
                obscureText: true,
                style: TextStyle(color: Colors.white),
                validator: (value) =>
                    value == null || value.length < 6 ? 'Password too short' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Get.to(LoginPage());
                },
                child: const Text(
                  'Already have an account? Log in',
                  style: TextStyle(color: Colors.tealAccent),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}