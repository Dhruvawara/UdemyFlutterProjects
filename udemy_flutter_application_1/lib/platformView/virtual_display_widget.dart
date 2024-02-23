
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class VirtualDisplayWidget extends StatefulWidget {
  const VirtualDisplayWidget({super.key});

  /// Path: `/virtualDisplay`
  static const String routeName = "/virtualDisplay";

  @override
  State<VirtualDisplayWidget> createState() => _VirtualDisplayWidgetState();
}

class _VirtualDisplayWidgetState extends State<VirtualDisplayWidget> {
  Stream<String> streamSelectedStateFromNative() {
    return getStateDataHandlerEvent.receiveBroadcastStream().map((event) {
      return event.toString();
    });
  }

  final EventChannel getStateDataHandlerEvent =
      const EventChannel('getStateDataHandlerPlatformEvent');

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = "VirtualDisplayWidget";
    // Pass parameters to the platform side.
    const Map<String, dynamic> creationParams = <String, dynamic>{};

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: const AndroidView(
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: StandardMessageCodec(),
          ),
        ),
        const Gap(7),
        StreamBuilder<String>(
          stream: streamSelectedStateFromNative(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('Selected City StateName -  ${snapshot.data}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        const Gap(7),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_circle_left_outlined),
          label: const Text('Back'),
        ),
      ],
    );
  }
}
