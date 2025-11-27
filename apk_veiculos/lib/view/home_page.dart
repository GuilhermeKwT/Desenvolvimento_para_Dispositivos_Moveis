import 'package:apk_veiculos/database/helper/car_helper.dart';
import 'package:apk_veiculos/database/model/car_model.dart';
import 'package:apk_veiculos/view/car_update_page.dart';
import 'package:apk_veiculos/view/car_details_page.dart';
import 'package:apk_veiculos/view/components/car_card.dart';
import 'package:apk_veiculos/view/components/app_scaffold.dart';
import 'package:apk_veiculos/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CarHelper helper = CarHelper();
  List<Car> cars = [];

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    final list = await helper.getAllCars();
    setState(() {
      cars = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Meus Veículos',
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addCar();
        },
        backgroundColor: AppTheme.primaryPurple,
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Image.asset(
                'assets/imgs/car.png',
                fit: BoxFit.contain,
                color: Colors.white.withAlpha(30),
                colorBlendMode: BlendMode.modulate,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
            child: ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: cars.length,
              itemBuilder: (context, index) {
                return TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 350 + (index * 80)),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 20),
                        child: child,
                      ),
                    );
                  },
                  child: CarCard(
                    car: cars[index],
                    onTap: () => _viewCarDetails(cars[index]),
                    onLongPress: () => _showCarMenu(context, cars[index]),
                  ),
                );
              },
            ),
          ),
        ],
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
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CarDetailsPage(car: car)),
    );
    _loadCars();
    
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
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _editCarFromMenu(car);
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteCarFromMenu(car);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Excluir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.darkGray,
                  foregroundColor: AppTheme.textSecondary,
                  side: const BorderSide(color: AppTheme.borderGray),
                ),
                child: const Text('Cancelar'),
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
      final helper = CarHelper();
      await helper.deleteCar(car.id!);
      _loadCars();
    }
  }
}
