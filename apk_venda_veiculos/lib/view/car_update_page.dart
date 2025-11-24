import 'dart:io';

import 'package:apk_venda_veiculos/service/firestore_service.dart';
import 'package:apk_venda_veiculos/service/entities/car_model.dart';
import 'package:apk_venda_veiculos/view/components/app_scaffold.dart';
import 'package:apk_venda_veiculos/view/components/labeled_dropdown.dart';
import 'package:apk_venda_veiculos/view/components/labeled_text_field.dart';
import 'package:apk_venda_veiculos/core/input_formatters.dart';
import 'package:apk_venda_veiculos/core/validators.dart';
import 'package:apk_venda_veiculos/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class CarUpdatePage extends StatefulWidget {
  final Car? car;
  const CarUpdatePage({super.key, this.car});

  @override
  State<CarUpdatePage> createState() => _CarUpdatePageState();
}

class _CarUpdatePageState extends State<CarUpdatePage> {
  Car? _editedCar;
  final _formKey = GlobalKey<FormState>();
  bool _imageExists = true;

  final _firestoreService = FirestoreService();

  final _renavamController = TextEditingController();
  final _modelController = TextEditingController();
  final _brandController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  final _plateController = TextEditingController();
  final _fuelController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (widget.car == null) {
      _editedCar = Car(
        type: '',
        renavam: '',
        model: '',
        brand: '',
        year: '',
        color: '',
      );
    } else {
      _editedCar = widget.car;

      _renavamController.text = _editedCar?.renavam ?? '';
      _modelController.text = _editedCar?.model ?? '';
      _brandController.text = _editedCar?.brand ?? '';
      _yearController.text = _editedCar?.year ?? '';
      _colorController.text = _editedCar?.color ?? '';
      _plateController.text = _editedCar?.plate ?? '';
      _fuelController.text = _editedCar?.fuel ?? '';
    }
    _validateImage();
  }

  @override
  Widget build(BuildContext context) {
    final years = <String>[];
    final currentYear = DateTime.now().year;
    for (var y = currentYear; y >= 1900; y--) {
      years.add(y.toString());
    }

    final fuelOptions = <String>[
      'Gasolina',
      'Etanol',
      'Diesel',
      'Flex',
      'Elétrico',
      'GNV',
      'Outro',
    ];

    return AppScaffold(
      title: 'Veículos',
      showBackButton: true,
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
              padding: const EdgeInsets.all(14.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () => _selectImage(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadiusSmall,
                          ),
                          child: Container(
                            width: 140.0,
                            height: 140.0,
                            color: AppTheme.imagePlaceholderColor,
                            child:
                                _imageExists &&
                                    _editedCar?.img != null &&
                                    _editedCar!.img!.isNotEmpty
                                ? Image.file(
                                    File(_editedCar!.img!),
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
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _editedCar?.type.isNotEmpty == true
                          ? _editedCar?.type
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Tipo',
                        labelStyle: GoogleFonts.poppins(
                          color: AppTheme.inputLabelColor,
                        ),
                        filled: true,
                        fillColor: AppTheme.inputFillColor.withAlpha(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadiusMedium,
                          ),
                        ),
                      ),
                      items: <String>['Carro', 'Onibus', 'Caminhão', 'Outro']
                          .map(
                            (v) => DropdownMenuItem(
                              value: v,
                              child: Text(
                                v,
                                style: GoogleFonts.poppins(
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _editedCar?.type = newValue ?? '';
                        });
                      },
                      dropdownColor: AppTheme.darkGray,
                      style: GoogleFonts.poppins(color: AppTheme.textPrimary),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Tipo é obrigatório'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    LabeledTextField(
                      controller: _renavamController,
                      label: 'Renavam',
                      keyboardType: TextInputType.number,
                      inputFormatters: [RenavamMaskFormatter()],
                      validator: AppValidators.validateRenavam,
                      onChanged: (text) => _editedCar?.renavam = text,
                    ),
                    const SizedBox(height: 12),
                    LabeledTextField(
                      controller: _modelController,
                      label: 'Modelo',
                      validator: (v) =>
                          v?.isEmpty == true ? 'Modelo é obrigatório' : null,
                      onChanged: (text) => _editedCar?.model = text,
                    ),
                    const SizedBox(height: 12),
                    LabeledTextField(
                      controller: _brandController,
                      label: 'Marca',
                      validator: (v) =>
                          v?.isEmpty == true ? 'Marca é obrigatória' : null,
                      onChanged: (text) => _editedCar?.brand = text,
                    ),
                    const SizedBox(height: 12),
                    LabeledTextField(
                      controller: _yearController,
                      label: 'Ano',
                      readOnly: true,
                      validator: (v) =>
                          v?.isEmpty == true ? 'Ano é obrigatório' : null,
                      onTap: () => _showYearPicker(context),
                    ),
                    const SizedBox(height: 12),
                    LabeledTextField(
                      controller: _colorController,
                      label: 'Cor',
                      onChanged: (text) => _editedCar?.color = text,
                    ),
                    const SizedBox(height: 12),
                    LabeledTextField(
                      controller: _plateController,
                      label: 'Placa',
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        PlateMaskFormatter(),
                      ],
                      validator: AppValidators.validatePlate,
                      onChanged: (text) => _editedCar?.plate = text,
                    ),
                    const SizedBox(height: 12),
                    LabeledDropdown(
                      label: 'Combustível',
                      value: _editedCar?.fuel,
                      items: fuelOptions,
                      onChanged: (val) {
                        setState(() {
                          _editedCar?.fuel = val ?? '';
                          _fuelController.text = val ?? '';
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveCar();
        },
        backgroundColor: AppTheme.primaryPurple,
        child: const Icon(Icons.save),
      ),
    );
  }

  Future<void> _selectImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        _editedCar?.img = image.path;
        _imageExists = true;
      });
    }
  }

  Future<void> _showYearPicker(BuildContext context) async {
    final currentYear = DateTime.now().year;
    final minYear = 1900;
    final maxYear = currentYear;
    final initialYear =
        (_editedCar?.year != null && _editedCar!.year.isNotEmpty)
        ? (int.tryParse(_editedCar!.year) ?? currentYear)
        : currentYear;

    final picked = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.darkGray,
          title: Text(
            'Selecione o ano',
            style: GoogleFonts.poppins(color: AppTheme.textPrimary),
          ),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(minYear),
              lastDate: DateTime(maxYear),
              selectedDate: DateTime(initialYear),
              onChanged: (DateTime date) {
                Navigator.of(context).pop(date.year);
              },
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _editedCar?.year = picked.toString();
        _yearController.text = picked.toString();
      });
    }
  }

  void _saveCar() {
    if (!_formKey.currentState!.validate()) return;

    if (_editedCar?.year.isEmpty == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ano é obrigatório')));
      return;
    }

    if (_editedCar?.img == "") {
      _editedCar?.img = null;
    }

    _savingCar();
  }

  Future<void> _savingCar() async {
    try {
      if (_editedCar!.id == null) {
        await _firestoreService.saveCar(_editedCar!);
      } else {
        await _firestoreService.updateCar(_editedCar!);
      }
      if (!mounted) return;
      Navigator.pop(context, _editedCar);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar veículo: $e')));
    }
  }

  Future<void> _validateImage() async {
    final exists = await File(_editedCar?.img ?? '').exists();
    if (mounted) {
      setState(() {
        _imageExists = exists;
      });
    }
  }
}
