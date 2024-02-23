import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class EventChannelWidget extends StatefulWidget {
  const EventChannelWidget({super.key});

  /// Path: `/eventChannel`
  static const String routeName = "/eventChannel";

  @override
  State<EventChannelWidget> createState() => _EventChannelWidgetState();
}

class _EventChannelWidgetState extends State<EventChannelWidget> {
  final EventChannel eventChannelGetCityData =
      const EventChannel('getCityDataHandlerEvent');

  final EventChannel eventChannelGetStateData =
      const EventChannel('getStateDataHandlerEvent');

  final EventChannel eventChannelTimer = const EventChannel('timeHandlerEvent');
  StreamSubscription? streamSubscriptionCity;
  StreamSubscription? streamSubscriptionState;

  List<String> _cityDataModel = [];
  String _stateName = '';

  @override
  void dispose() {
    streamSubscriptionCity?.cancel();
    streamSubscriptionCity = null;
    streamSubscriptionState?.cancel();
    streamSubscriptionState = null;
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () => getCityData());
  }

  void getCityData() {
    streamSubscriptionCity =
        eventChannelGetCityData.receiveBroadcastStream().listen((dynamicEvent) {
      setState(() {
        _cityDataModel =
            (dynamicEvent as List).map((e) => e.toString()).toList();
      });
      streamSubscriptionCity?.cancel();
    });
  }

  getStateFromCity(String cityName) async {
    streamSubscriptionState = eventChannelGetStateData
        .receiveBroadcastStream(cityName)
        .listen((dynamicEvent) {
      setState(() {
        _stateName = dynamicEvent as String;
      });
      streamSubscriptionState?.cancel();
    });
  }

  Stream<String> streamTimeFromNative() {
    return eventChannelTimer
        .receiveBroadcastStream()
        .map((event) => event.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(7),
          StreamBuilder<String>(
            stream: streamTimeFromNative(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('${snapshot.data}');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          const Gap(7),
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
