import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:apk_venda_veiculos/view/components/app_scaffold.dart';
import 'package:apk_venda_veiculos/view/components/labeled_text_field.dart';
import 'package:apk_venda_veiculos/core/theme.dart';
import 'package:apk_venda_veiculos/core/input_formatters.dart';
import 'package:apk_venda_veiculos/core/validators.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Meu Perfil',
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
                              Icons.person_rounded,
                              size: 56,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Editar Perfil',
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
                      controller: _nameController,
                      label: 'Nome',
                      keyboardType: TextInputType.name,
                      validator: AppValidators.validateName,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 12),
                    LabeledTextField(
                      controller: _emailController,
                      label: 'Email',
                      readOnly: true,
                    ),
                    const SizedBox(height: 12),
                    LabeledTextField(
                      controller: _phoneController,
                      label: 'Telefone',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        PhoneMaskFormatter(),
                      ],
                      validator: AppValidators.validatePhone,
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loading ? null : _saveProfile,
        backgroundColor: AppTheme.primaryPurple,
        child: _loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.save),
      ),
    );
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;
    _emailController.text = user.email ?? '';
    _nameController.text = user.displayName ?? '';

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['phone'] != null) {
          _phoneController.text = data['phone'];
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados do usuário: $e')),
      );
    }
    if (mounted) setState(() {});
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final user = _auth.currentUser;
    if (user == null) return;

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    try {
      await user.updateDisplayName(name);

      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'phone': phone,
        'email': user.email,
        'updatedAt': DateTime.now(),
      }, SetOptions(merge: true));

      if (!mounted) return;
      Navigator.pop(context, true);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Erro ao atualizar perfil')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar perfil: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
