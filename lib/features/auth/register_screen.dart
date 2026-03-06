// lib/features/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'widgets/auth_textfield.dart';
import '../../core/utils/validators.dart';
import '../../features/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../routing/route_names.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.register(
        _name.text.trim(),
        _email.text.trim(),
        _password.text.trim(),
      );
      // On success navigate to Home
      Navigator.pushReplacementNamed(context, RouteNames.home);
    } on Exception catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AuthTextField(
                    controller: _name,
                    label: 'Full name',
                    validator: (v) => Validators.nonEmpty(v, 'Name'),
                  ),
                  const SizedBox(height: 10),
                  AuthTextField(
                    controller: _email,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 10),
                  AuthTextField(
                    controller: _password,
                    label: 'Password',
                    obscureText: true,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 16),
                  _loading || authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            child: const Text('Create account'),
                          ),
                        ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, RouteNames.login),
                    child: const Text('Already have an account? Login'),
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
