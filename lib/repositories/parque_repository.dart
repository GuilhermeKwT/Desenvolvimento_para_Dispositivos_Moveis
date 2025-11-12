import 'package:flutter/material.dart';
import 'package:geo_loc/model/parque.dart';

class ParqueRepository extends ChangeNotifier{
  final List<Parque> _parques = [
    Parque(
      nome: 'Parque do Lago',
      endereco: 'R. Padre Chagas, 3808 - Centro, Guarapuava - PR,',
      foto:
          'https://lh3.googleusercontent.com/gps-cs-s/AC9h4npkLV3SDIWmWGJO1MCtStES11koh9STB538IB7DX068Wv_oiGhZXf_q-lxcuRK1LWeFmEMyI5Erq2wUWz1qyIocJPzuFVnU9p4QFMNfOYYuo-o15_QJpDaW7XmpR2WGfwZ497xS=w270-h312-n-k-no',
      latitude: -25.39749,
      longitude: -51.47169,
    ),
    Parque(
      nome: 'Lagoa das Lágrimas',
      endereco: 'R. Prof. Becker, 1324 - Centro, Guarapuava - PR',
      foto:
          'https://lh3.googleusercontent.com/gps-cs-s/AC9h4nqDiErq92i4axWsgP-R_fVy65BdHL3vfh5g5bKXdQEYwg7JnUymqeLPezxIbWnPGOVRAnIov1I2L-Ou0SBbope5vEwA279F_a_LFtzQJA9trXGMgjdJx5GW-mCHrfIEG1D9Vk_W=w408-h306-k-no',
      latitude: -25.39516,
      longitude: -51.46189,
    ),
    Parque(
      nome: 'Parque das Araucárias',
      endereco: 'R. Alzino Carazzai - Guarapuava, PR',
      foto:
          'https://lh3.googleusercontent.com/gps-cs-s/AC9h4nqT69jYiuGS4ZQlTdbe3ToXTPwM3A9z3Pxz8bsSbcNQv66FG-_3R-jvittxjEXBtPH-dNIkoshhfzDxC8lgcuiRjUo0UgO6_XkjU1Th6Vwu7TJ0zZCqn-fTXP_HNr0ap06B7zhl=w408-h306-k-no',
      latitude: -25.35811,
      longitude: -51.46568,
    ),
  ];

  List<Parque> get parques => _parques;
}