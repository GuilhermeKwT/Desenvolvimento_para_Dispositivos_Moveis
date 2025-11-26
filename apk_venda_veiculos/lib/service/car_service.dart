import 'package:apk_venda_veiculos/model/car.dart';
import 'package:apk_venda_veiculos/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();

  CollectionReference get _carsCollection {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('Usuário não autenticado');
    }
    return _firestore.collection('users').doc(userId).collection('cars');
  }

  Future<String> saveCar(Car car) async {
    try {
      final docRef = await _carsCollection.add({
        'type': car.type,
        'renavam': car.renavam,
        'model': car.model,
        'brand': car.brand,
        'year': car.year,
        'color': car.color,
        'plate': car.plate,
        'fuel': car.fuel,
        'img': car.img,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      car.id = docRef.id;

      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao salvar carro: $e');
    }
  }

  Future<Car?> getCar(String docId) async {
    try {
      final doc = await _carsCollection.doc(docId).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return _carFromFirestore(doc.id, data);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar carro: $e');
    }
  }

  Future<List<Car>> getAllCars() async {
    try {
      final snapshot = await _carsCollection
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) =>
                _carFromFirestore(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar todos os carros: $e');
    }
  }

  Future<void> updateCar(Car car) async {
    try {
      if (car.id == null) {
        throw Exception('Id do carro não está definido');
      }

      await _carsCollection.doc(car.id).update({
        'type': car.type,
        'renavam': car.renavam,
        'model': car.model,
        'brand': car.brand,
        'year': car.year,
        'color': car.color,
        'plate': car.plate,
        'fuel': car.fuel,
        'img': car.img,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao atualizar carro: $e');
    }
  }

  Future<void> deleteCar(String docId) async {
    try {
      await _carsCollection.doc(docId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar carro: $e');
    }
  }

  Car _carFromFirestore(String id, Map<String, dynamic> data) {
    return Car(
      id: id,
      type: data['type'] ?? '',
      renavam: data['renavam'],
      model: data['model'] ?? '',
      brand: data['brand'] ?? '',
      year: data['year'] ?? '',
      color: data['color'] ?? '',
      plate: data['plate'],
      fuel: data['fuel'],
      img: data['img'],
    );
  }
}
