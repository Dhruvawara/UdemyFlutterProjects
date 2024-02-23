import 'dart:io';

import 'package:favorite_places/model/place_model.dart';
import 'package:favorite_places/provider/places_provider.dart';
import 'package:favorite_places/widget/image_input.dart';
import 'package:favorite_places/widget/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  String placeName = "";
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  PlaceLocationModel? _selectedLocation;

  void _onAddClicked() {
    if (_selectedImage == null || _selectedLocation == null) {
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ref
          .read(placesProvider.notifier)
          .addPlace(placeName, _selectedImage!, _selectedLocation!);

      Navigator.pop(context);
    }
  }

  void _onImageSelected(File image) {
    _selectedImage = image;
  }

  void _onPlaceSelected(PlaceLocationModel placeLocationModel) {
    _selectedLocation = placeLocationModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Place Name'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Data Boi";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  placeName = newValue!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ImageInput(
                onPickImage: _onImageSelected,
              ),
              const SizedBox(
                height: 20,
              ),
              LocationInput(onPickLocation: _onPlaceSelected),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: _onAddClicked,
                icon: const Icon(Icons.add),
                label: const Text('Add Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
