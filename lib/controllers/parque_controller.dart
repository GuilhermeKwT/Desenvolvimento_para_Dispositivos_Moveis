import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ParqueController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String erro = '';
  bool isLoading = true;

  ParqueController() {
    getPosicao();
  }

  getPosicao() async {
    try {
      Position position = await _posicaoAtual();
      lat = position.latitude;
      long = position.longitude;
    } catch (e) {
      erro = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<Position> _posicaoAtual() async {
    LocationPermission permission;
    bool active = await Geolocator.isLocationServiceEnabled();
    if (!active) {
      return Future.error('Por favor, habilite sua localização');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
          'Você precisa habilitar o acesso a sua localização',
        );
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Você precisa habilitar o acesso a sua localização');
    }
    return await Geolocator.getCurrentPosition();
  }
}
