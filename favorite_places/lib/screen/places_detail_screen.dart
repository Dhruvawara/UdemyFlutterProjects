import 'package:favorite_places/model/place_model.dart';
import 'package:favorite_places/provider/places_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesDetailScreen extends ConsumerWidget {
  const PlacesDetailScreen(this.id, {super.key});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PlaceModel? place = ref.read(placesProvider.notifier).getPlace(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(place!.name),
      ),
      body: Stack(
        children: [
          Hero(
            tag: ValueKey(id),
            child: Image.file(
              place.image,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }
}
