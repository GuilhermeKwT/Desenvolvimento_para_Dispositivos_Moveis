import 'package:apk_venda_veiculos/core/input_formatters.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:apk_venda_veiculos/core/validators.dart';
import 'package:apk_venda_veiculos/view/components/app_scaffold.dart';
import 'package:apk_venda_veiculos/view/components/labeled_text_field.dart';
import 'package:apk_venda_veiculos/view/components/primary_button.dart';
import 'package:apk_venda_veiculos/core/theme.dart';
import 'package:apk_venda_veiculos/view/my_cars_page.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Cadastrar',
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
                              Icons.person_add_rounded,
                              size: 56,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Criar Conta',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Preencha os dados abaixo',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    LabeledTextField(
                      controller: _nameController,
                      label: 'Nome Completo',
                      keyboardType: TextInputType.name,
                      validator: AppValidators.validateName,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 12),
                    LabeledTextField(
                      controller: _emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: AppValidators.validateEmail,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 12),
                    LabeledTextField(
                      controller: _phoneController,
                      label: 'Telefone para Contato',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        PhoneMaskFormatter(),
                      ],
                      validator: AppValidators.validatePhone,
                      onChanged: (_) {},
                      suffixIcon: Icon(
                        Icons.phone_rounded,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LabeledTextField(
                      controller: _passwordController,
                      label: 'Senha',
                      obscureText: _obscurePassword,
                      validator: _validatePassword,
                      onChanged: (_) => setState(() {}),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppTheme.textSecondary,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    LabeledTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirmar Senha',
                      obscureText: _obscureConfirmPassword,
                      validator: _validateConfirmPassword,
                      onChanged: (_) => setState(() {}),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppTheme.textSecondary,
                        ),
                        onPressed: () => setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      onPressed: _loading ? null : _register,
                      label: 'Cadastrar',
                      loading: _loading,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Já tem uma conta? ',
                          style: GoogleFonts.poppins(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: _loading
                              ? null
                              : () => Navigator.pop(context),
                          child: Text(
                            'Entrar',
                            style: GoogleFonts.poppins(
                              color: AppTheme.primaryPurple,
                              fontWeight: FontWeight.w600,
                            ),
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Senha é obrigatória';
    if (value.length < 6) return 'Senha deve ter ao menos 6 caracteres';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    if (value != _passwordController.text) return 'Senhas não correspondem';
    return null;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();

      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(name);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'name': name,
            'email': email,
            'phone': phone,
            'createdAt': DateTime.now(),
            'updatedAt': DateTime.now(),
          });

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyCarsPage()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'email-already-in-use') {
        message = 'Este email já está registrado';
      } else if (e.code == 'weak-password') {
        message = 'Senha fraca. Use uma senha mais forte';
      } else {
        message = e.message ?? 'Erro ao registrar';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro inesperado ao registrar')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
