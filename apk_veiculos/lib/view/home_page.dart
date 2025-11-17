import 'package:apk_veiculos/database/helper/car_helper.dart';
import 'package:apk_veiculos/database/model/car_model.dart';
import 'package:flutter/material.dart';

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
    helper.getAllCars().then((list) {
      setState(() {
        cars = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 70, 10, 168),
            const Color.fromARGB(255, 42, 40, 44),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Veículos", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(180, 48, 48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            side: BorderSide(color: const Color.fromARGB(120, 0, 0, 0), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _carCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(child: Padding(padding: EdgeInsets.all(10))),
    );
  }
}
