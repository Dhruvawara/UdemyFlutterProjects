import 'dart:io';

import 'package:favorite_places/model/place_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as systemPath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDataBaseConnection() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, name TEXT, image TEXT, latitude REAL, longitude REAL, address TEXT)');
    },
    version: 1,
  );
  return db;
}

class PlacesProvider extends StateNotifier<List<PlaceModel>> {
  PlacesProvider() : super(const []);

  void addPlace(String name, File image, PlaceLocationModel location) async {
    final appDir = await systemPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');

    var tempData = PlaceModel(name: name, image: copiedImage, location: location);

    final db = await _getDataBaseConnection();

    await db.insert('user_places', {
      'id': tempData.id,
      'name': tempData.name,
      'image': tempData.image.path,
      'latitude': tempData.location.latitude,
      'longitude': tempData.location.longitude,
      'address': '',
    });

    state = [
      ...state,
      tempData,
    ];
  }

  Future<void> loadPlaces() async {
    final db = await _getDataBaseConnection();
    final data = await db.query('user_places');

    final places = data
        .map(
          (e) => PlaceModel(
            id: e['id'] as String,
            name: e['name'] as String,
            image: File(e['image'] as String),
            location: PlaceLocationModel(
              latitude: e['latitude'] as double,
              longitude: e['longitude'] as double,
              address: e['address'] as String,
            ),
          ),
        )
        .toList();

    state = places;
  }

  PlaceModel? getPlace(String id) {
    PlaceModel? tempPlace;

    for (var place in state) {
      if (id == place.id) {
        tempPlace = place;
        break;
      }
    }

    return tempPlace;
  }
}

final placesProvider = StateNotifierProvider<PlacesProvider, List<PlaceModel>>(
  (ref) => PlacesProvider(),
);
