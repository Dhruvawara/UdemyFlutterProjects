import 'package:favorite_places/model/place_model.dart';
import 'package:favorite_places/provider/places_provider.dart';
import 'package:favorite_places/screen/add_place_screen.dart';
import 'package:favorite_places/screen/places_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesListScreen extends ConsumerStatefulWidget {
  const PlacesListScreen({super.key});

  @override
  ConsumerState<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends ConsumerState<PlacesListScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(placesProvider.notifier).loadPlaces();
  }

  void _openAddPlace(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPlaceScreen(),
      ),
    );
  }

  void _openPlaceDetail(BuildContext context, PlaceModel placeModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacesDetailScreen(placeModel.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final placesList = ref.watch(placesProvider);
    
    Widget content = const Center(
      child: Text("No Data"),
    );

    if (placesList.isNotEmpty) {
      content = FutureBuilder(
        future: _placesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.separated(
              padding: const EdgeInsets.all(15),
              itemCount: placesList.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: 15,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => _openPlaceDetail(
                    context,
                    placesList[index],
                  ),
                  leading: Hero(
                    tag: ValueKey(placesList[index].id),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: FileImage(placesList[index].image),
                    ),
                  ),
                  title: Text(
                    placesList[index].name,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  subtitle: Text(
                      "${placesList[index].location.latitude} \t ${placesList[index].location.longitude}"),
                );
              },
            );
          } else {
            return const Center(
              child: Text("No Data"),
            );
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () => _openAddPlace(context),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: content,
    );
  }
}
