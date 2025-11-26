import 'package:apk_venda_veiculos/model/car.dart';
import 'package:apk_venda_veiculos/service/firestore_service.dart';
import 'package:apk_venda_veiculos/view/car_update_page.dart';
import 'package:apk_venda_veiculos/view/car_details_page.dart';
import 'package:apk_venda_veiculos/view/components/car_card.dart';
import 'package:apk_venda_veiculos/view/components/app_scaffold.dart';
import 'package:apk_venda_veiculos/view/components/primary_button.dart';
import 'package:apk_venda_veiculos/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCarsPage extends StatefulWidget {
  const MyCarsPage({super.key});

  @override
  State<MyCarsPage> createState() => _MyCarsPageState();
}

class _MyCarsPageState extends State<MyCarsPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Car> cars = [];
  Map<String, String> carDocIds = {};

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Veículos',
      showBackButton: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addCar();
        },
        backgroundColor: AppTheme.primaryPurple,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: cars.length,
        itemBuilder: (context, index) {
          return CarCard(
            car: cars[index],
            onTap: () => _viewCarDetails(cars[index]),
            onLongPress: () => _showCarMenu(context, cars[index]),
          );
        },
      ),
    );
  }

  void _addCar() async {
    final updatedContact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CarUpdatePage(car: null)),
    );
    if (updatedContact != null) {
      _loadCars();
    }
  }

  void _viewCarDetails(Car car) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CarDetailsPage(car: car)),
    );
    if (result != null) {
      _loadCars();
    }
  }

  void _showCarMenu(BuildContext context, Car car) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkGray,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.borderRadiusLarge),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${car.brand} ${car.model}',
              style: GoogleFonts.poppins(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () {
                  Navigator.pop(context);
                  _editCarFromMenu(car);
                },
                icon: Icons.edit,
                label: 'Editar',
                fullWidth: true,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteCarFromMenu(car);
                },
                icon: Icons.delete,
                label: 'Excluir',
                fullWidth: true,
                backgroundColor: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () => Navigator.pop(context),
                label: 'Cancelar',
                fullWidth: true,
                backgroundColor: AppTheme.darkGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editCarFromMenu(Car car) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CarUpdatePage(car: car)),
    );
    if (result != null) {
      _loadCars();
    }
  }

  void _deleteCarFromMenu(Car car) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkGray,
        title: Text(
          'Confirmar exclusão',
          style: GoogleFonts.poppins(color: AppTheme.textPrimary),
        ),
        content: Text(
          'Tem certeza que deseja excluir ${car.brand} ${car.model}?',
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
        if (car.id != null) {
          await _firestoreService.deleteCar(car.id!);
          if (!mounted) return;
          _loadCars();
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro: ID do documento não encontrado'),
            ),
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

  Future<void> _loadCars() async {
    try {
      final list = await _firestoreService.getAllCars();
      if (!mounted) return;
      setState(() {
        cars = list;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar veículos: $e')));
    }
  }
}
