import 'package:apk_venda_veiculos/core/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:apk_venda_veiculos/view/components/app_scaffold.dart';
import 'package:apk_venda_veiculos/view/components/labeled_text_field.dart';
import 'package:apk_venda_veiculos/view/components/primary_button.dart';
import 'package:apk_venda_veiculos/core/theme.dart';
import 'package:apk_venda_veiculos/view/my_cars_page.dart';
import 'package:apk_venda_veiculos/view/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscure = true;


  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Entrar',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.inputFillColor.withAlpha(10),
                borderRadius: BorderRadius.circular(
                  AppTheme.borderRadiusMedium,
                ),
                border: Border.all(color: AppTheme.borderGray),
              ),
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppTheme.imagePlaceholderColor,
                              borderRadius: BorderRadius.circular(
                                AppTheme.borderRadiusSmall,
                              ),
                            ),
                            child: Icon(
                              Icons.directions_car_rounded,
                              size: 56,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Bem-vindo',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    LabeledTextField(
                      controller: _emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: AppValidators.validateEmail,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 12),
                    LabeledTextField(
                      controller: _passwordController,
                      label: 'Senha',
                      obscureText: _obscure,
                      validator: AppValidators.validateNotEmpty,
                      onChanged: (_) {},
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: AppTheme.textSecondary,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    const SizedBox(height: 18),
                    PrimaryButton(
                      onPressed: _loading ? null : _signIn,
                      label: 'Entrar',
                      loading: _loading,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _loading
                              ? null
                              : () async {
                                  final email = _emailController.text.trim();
                                  if (email.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Informe o email para recuperar a senha',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  try {
                                    await FirebaseAuth.instance
                                        .sendPasswordResetEmail(email: email);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Email de recuperação enviado',
                                        ),
                                      ),
                                    );
                                  } on FirebaseAuthException catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.message ?? 'Erro'),
                                      ),
                                    );
                                  }
                                },
                          child: Text(
                            'Esqueci a senha',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        ),
                        TextButton(
                          onPressed: _loading
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterPage(),
                                    ),
                                  );
                                },
                          child: Text(
                            'Registrar',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyCarsPage()),
      );
    } on FirebaseAuthException catch (e) {
      final message = 'Erro ao autenticar';
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro inesperado ao autenticar')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
