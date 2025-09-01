import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../strings.dart';

import '../../repositories/auth_repository.dart';
import '../../services/user_manager.dart';
import '../../utils/branding.dart';

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
      appBar: AppBar(title: Text(_isSignUp ? kCreateAccountLabel : kSignInLabel)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // App Logo
            const SizedBox(height: 32),
            Branding.logoLargeWidget(context),
            const SizedBox(height: 24),
            Text(
              kAppName,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              kAppTagline,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (_isSignUp)
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: kNameLabel),
              ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: kEmailLabel),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: kPasswordLabel),
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
                            final user = await auth.signUp(
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );
                            if (user != null) {
                              UserManager.instance.setCurrentUserId(user.uid);
                            }
                          } else {
                            final user = await auth.signIn(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );
                            if (user != null) {
                              UserManager.instance.setCurrentUserId(user.uid);
                            }
                          }
                          if (context.mounted) context.go('/home');
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$kAuthErrorLabel$e')),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _loading = false);
                        }
                      },
                child: Text(_isSignUp ? kSignUpLabel : kSignInLabel),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _isSignUp = !_isSignUp),
              child: Text(
                _isSignUp ? kHaveAccountLabel : kCreateAccountPromptLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
