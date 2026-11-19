import 'package:flutter/material.dart';
import 'navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login', style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.bold, fontSize: 30
        )
      ),
        backgroundColor: const Color.fromARGB(255, 3, 12, 90),
      ),
      body: Center(
       child: Container(
        padding: const EdgeInsets.all(45),
        margin: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.blueGrey.withOpacity(0.3), 
          blurRadius: 10, 
          spreadRadius: 2,
          //offset: Offset(0, 5)
          )
        ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Nom d'utilisateu",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainNavigation()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 3, 12, 90),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Se connecter',
              style: TextStyle(fontSize: 18),
              ),
           ) 
          ],
        ),
      ),
    ),
    );
  }
}