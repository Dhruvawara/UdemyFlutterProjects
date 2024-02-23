import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:udemy_flutter_application_1/methodChannel/city_model.dart';
import 'package:udemy_flutter_application_1/methodChannel/device_model.dart';

class MethodChannelWidget extends StatefulWidget {
  const MethodChannelWidget({super.key});

  /// Path: `/methodChannel`
  static const String routeName = "/methodChannel";

  @override
  State<MethodChannelWidget> createState() => _MethodChannelWidgetState();
}

class _MethodChannelWidgetState extends State<MethodChannelWidget> {
  List<String> _cityDataModel = [];
  String _deviceModel = '';
  String _stateName = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => getDeviceModel());
    Future.delayed(Duration.zero, () => getCityData());
  }

  getDeviceModel() async {
    await DeviceModel.getDeviceModel().then((value) {
      setState(() {
        _deviceModel = value;
      });
    });
  }

  getCityData() async {
    await CityModel.getCityModel().then((value) {
      setState(() {
        _cityDataModel = value;
      });
    });
  }

  getStateFromCity(String cityName) async {
    await CityModel.getStateFromCity(cityName).then((value) {
      setState(() {
        _stateName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownMenu(
            dropdownMenuEntries: _cityDataModel
                .map((String e) => DropdownMenuEntry(value: e, label: e))
                .toList(),
            onSelected: (value) {
              if (value != null) {
                Future.delayed(Duration.zero, () => getStateFromCity(value));
              }
            },
            width: 200,
          ),
          const Gap(7),
          Text('Selected City StateName - $_stateName'),
          const Gap(7),
          Text('Device Model - $_deviceModel'),
          const Gap(7),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_circle_left_outlined),
            label: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
