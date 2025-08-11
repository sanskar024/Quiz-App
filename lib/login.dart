        import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:untitled/ques_database';
import 'package:untitled/quiz_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final db = DBHelper();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
            //  backgroundImage: AssetImage('assets/images/profile.png'),
              backgroundColor: Colors.tealAccent,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            TextField(
              controller: usernameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person, color: Colors.tealAccent),
                hintText: 'Enter your username',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock, color: Colors.tealAccent),
                hintText: 'Enter your password',
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () async {
                  final username = usernameController.text.trim();
                  final password = passwordController.text.trim();
                  
                  if (username.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter both username and password'),
                        backgroundColor: Colors.red[700],
                      ),
                    );
                    return;
                  }
                  
                  final ans = await db.getUser(username, password);
                  
                  if (ans != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Login Successful'),
                        backgroundColor: Colors.green[700],
                      ),
                    );
                    
                    final shprf = await SharedPreferences.getInstance();
                    await shprf.setBool("isLoggedIn", true);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => QuizPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Invalid username or password'),
                        backgroundColor: Colors.red[700],
                      ),
                    );
                  }
                },
                child: Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
             
            ), 
          ],
        ),
      ),
    );
  }
}
