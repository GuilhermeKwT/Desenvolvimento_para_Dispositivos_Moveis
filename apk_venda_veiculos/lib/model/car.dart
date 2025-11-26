String idColumn = 'idColumn';
String typeColumn = 'typeColumn';
String renavamColumn = 'renavamColumn';
String modelColumn = 'modelColumn';
String brandColumn = 'brandColumn';
String yearColumn = 'yearColumn';
String colorColumn = 'colorColumn';
String plateColumn = 'plateColumn';
String fuelColumn = 'fuelColumn';
String imgColumn = 'imgColumn';
String carTable = 'carTable';

class Car {
  Car({
    this.id,
    required this.type,
    this.renavam,
    required this.model,
    required this.brand,
    required this.year,
    required this.color,
    this.plate,
    this.fuel,
    this.img,
  });

  String? id;
  String type;
  String? renavam;
  String model;
  String brand;
  String year;
  String color;
  String? plate;
  String? fuel;
  String? img;

  Car.fromMap(Map<String, dynamic> map)
    : id = map[idColumn],
      type = map[typeColumn],
      renavam = map[renavamColumn],
      model = map[modelColumn],
      brand = map[brandColumn],
      year = map[yearColumn],
      color = map[colorColumn],
      plate = map[plateColumn],
      fuel = map[fuelColumn],
      img = map[imgColumn];

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      typeColumn: type,
      renavamColumn: renavam,
      modelColumn: model,
      brandColumn: brand,
      yearColumn: year,
      colorColumn: color,
      plateColumn: plate,
      fuelColumn: fuel,
      imgColumn: img,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'Car{id: $id, type: $type, renavam: $renavam, model: $model, brand: $brand, year: $year, color: $color, plate: $plate, fuel: $fuel, img: $img}';
  }
}
