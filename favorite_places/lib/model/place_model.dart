// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class PlaceModel {
  PlaceModel({
    required this.name,
    required this.image,
    required this.location,
    String? id,
  }) : id = id ?? _uuid.v4();

  final String id;
  final String name;
  final File image;
  final PlaceLocationModel location;
}

class PlaceLocationModel {
  final double latitude;
  final double longitude;
  final String address;
  PlaceLocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}
