import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../repositories/auth_repository.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isSignUp = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthRepository>();
    return Scaffold(
      appBar: AppBar(title: Text(_isSignUp ? 'Create Account' : 'Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isSignUp)
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading
                    ? null
                    : () async {
                        setState(() => _loading = true);
                        try {
                          if (_isSignUp) {
                            await auth.signUp(
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );
                          } else {
                            await auth.signIn(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );
                          }
                          if (context.mounted) context.go('/home');
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Auth error: $e')),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _loading = false);
                        }
                      },
                child: Text(_isSignUp ? 'Sign Up' : 'Sign In'),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _isSignUp = !_isSignUp),
              child: Text(_isSignUp ? 'Have an account? Sign in' : 'Create an account'),
            )
          ],
        ),
      ),
    );
  }
}

