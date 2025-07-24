import 'package:app_sale_tickets/src/widgets/adaptive_screens_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String error = '';
  bool loading = false;

  Future<void> login() async {
    try {
      setState(() {
        loading = true;
      });
      await Future.delayed(Duration(seconds: 5));
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      GoRouter.of(context).go('/');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          error = 'Correo electrónico no registrado';
          loading = false;
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          error = 'Correo electrónico invalido';
          loading = false;
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          error = 'Contraseña incorrecta';
          loading = false;
        });
      } else {
        setState(() {
          error = e.message ?? 'Login error';
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AdaptiveScreensWidget(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                    ),
                    controller: _passwordController,
                    obscureText: true),
                const SizedBox(
                  height: 10,
                ),
                if (loading == false)
                  ElevatedButton(
                      onPressed: login, child: const Text('Ingresar'))
                else
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                if (error.isNotEmpty)
                  const SizedBox(
                    height: 15,
                  ),
                if (error.isNotEmpty)
                  Text(error, style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
