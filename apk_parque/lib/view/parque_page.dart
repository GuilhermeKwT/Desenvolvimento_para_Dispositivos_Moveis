import 'package:flutter/material.dart';
import 'package:geo_loc/controllers/parque_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

final appKey = GlobalKey();

class ParquePage extends StatelessWidget {
  const ParquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: appKey,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text("Meu Local"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider<ParqueController>(
        create: (context) => ParqueController(),
        child: Builder(
          builder: (context) {
            final local = context.watch<ParqueController>();

            /*
            String mensagem = local.erro == ''
                ? 'Latitude: ${local.lat} | Longitude: ${local.long}'
                : local.erro;
            return Center(child: Text(mensagem));
            */

            if (local.erro.isNotEmpty) {
              return Center(child: Text('Erro: ${local.erro}'));
            }
            if (local.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(local.lat, local.long),
                zoom: 16,
              ),
            );
          },
        ),
      ),
    );
  }
}
