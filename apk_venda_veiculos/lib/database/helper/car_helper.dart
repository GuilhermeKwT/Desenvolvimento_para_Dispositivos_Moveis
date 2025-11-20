import 'package:apk_veiculos/database/model/car_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CarHelper {
  static final CarHelper _instance = CarHelper.internal();
  factory CarHelper() => _instance;
  CarHelper.internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDb();
      return _db!;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "carsDB.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newVersion) async {
        await db.execute(
          "CREATE TABLE $carTable($idColumn INTEGER PRIMARY KEY, $typeColumn TEXT, $renavamColumn TEXT, $modelColumn TEXT, $brandColumn TEXT, $yearColumn TEXT, $colorColumn TEXT, $plateColumn TEXT, $fuelColumn TEXT, $imgColumn TEXT)",
        );
      },
    );
  }

  Future<Car> saveCar(Car car) async {
    Database dbCar = await db;
    car.id = await dbCar.insert(carTable, car.toMap());
    return car;
  }

  Future<Car?> getCar(int id) async {
    Database dbCar = await db;
    List<Map<String, dynamic>> maps = await dbCar.query(
      carTable,
      columns: [idColumn, typeColumn, renavamColumn, modelColumn, brandColumn, yearColumn, colorColumn, plateColumn, fuelColumn, imgColumn],
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Car.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Car>> getAllCars() async {
    Database dbCar = await db;
    List<Map<String, dynamic>> listMap = await dbCar.query(carTable);
    List<Car> listCar = [];
    for (Map<String, dynamic> m in listMap) {
      listCar.add(Car.fromMap(m));
    }
    return listCar;
  }

  Future<int> deleteCar(int id) async {
    Database dbCar = await db;
    return await dbCar.delete(
      carTable,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateCar(Car car) async {
    Database dbCar = await db;
    return await dbCar.update(
      carTable,
      car.toMap(),
      where: "$idColumn = ?",
      whereArgs: [car.id],
    );
  }
}
