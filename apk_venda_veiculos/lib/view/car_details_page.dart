import 'dart:io';

import 'package:apk_venda_veiculos/service/firestore_service.dart';
import 'package:apk_venda_veiculos/service/entities/car_model.dart';
import 'package:apk_venda_veiculos/view/car_update_page.dart';
import 'package:apk_venda_veiculos/view/components/app_scaffold.dart';
import 'package:apk_venda_veiculos/core/theme.dart';
import 'package:apk_venda_veiculos/view/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarDetailsPage extends StatefulWidget {
  final Car car;

  const CarDetailsPage({super.key, required this.car});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late Car _car;
  bool _imageExists = true;

  @override
  void initState() {
    super.initState();
    _car = widget.car;
    _validateImage();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '${_car.brand} ${_car.model}',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppTheme.borderRadiusMedium,
                  ),
                  child: Container(
                    height: 250,
                    color: AppTheme.imagePlaceholderColor,
                    child:
                        _imageExists && _car.img != null && _car.img!.isNotEmpty
                        ? Image.file(
                            File(_car.img!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/imgs/images.avif',
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/imgs/images.avif',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(10),
                    borderRadius: BorderRadius.circular(
                      AppTheme.borderRadiusMedium,
                    ),
                    border: Border.all(color: Colors.black26),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInfoRow('Marca', _car.brand),
                      const SizedBox(height: 12),
                      _buildInfoRow('Modelo', _car.model),
                      const SizedBox(height: 12),
                      _buildInfoRow('Tipo', _car.type),
                      const SizedBox(height: 12),
                      _buildInfoRow('Ano', _car.year),
                      const SizedBox(height: 12),
                      _buildInfoRow('Renavam', _car.renavam ?? 'N/A'),
                      const SizedBox(height: 12),
                      _buildInfoRow('Placa', _car.plate ?? 'N/A'),
                      const SizedBox(height: 12),
                      _buildInfoRow('Cor', _car.color),
                      const SizedBox(height: 12),
                      _buildInfoRow('Combustível', _car.fuel ?? 'N/A'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        onPressed: () => _editCar(),
                        icon: Icons.edit,
                        label: 'Editar',
                        fullWidth: true,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        onPressed: () => _deleteCar(),
                        icon: Icons.delete,
                        label: 'Excluir',
                        fullWidth: true,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.red[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: AppTheme.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _editCar() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CarUpdatePage(car: _car)),
    );
    if (result != null && mounted) {
      setState(() {
        _car = result;
      });
    }
  }

  Future<void> _deleteCar() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkGray,
        title: Text(
          'Confirmar exclusão',
          style: GoogleFonts.poppins(color: AppTheme.textPrimary),
        ),
        content: Text(
          'Tem certeza que deseja excluir ${_car.brand} ${_car.model}?',
          style: GoogleFonts.poppins(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(color: AppTheme.textPrimary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Excluir',
              style: GoogleFonts.poppins(color: Colors.red[400]),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        if (_car.id != null) {
          await _firestoreService.deleteCar(_car.id!);
          if (!mounted) return;
          Navigator.pop(context, true);
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro: ID do veículo não encontrado')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao deletar veículo: $e')));
      }
    }
  }

  Future<void> _validateImage() async {
    final exists = await File(_car.img ?? '').exists();
    if (mounted) {
      setState(() {
        _imageExists = exists;
      });
    }
  }
}
