
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class HybridCompositionWithRecycleViewWidget extends StatefulWidget {
  const HybridCompositionWithRecycleViewWidget({super.key});

  /// Path: `/hybridCompositionWithRecycle`
  static const String routeName = "/hybridCompositionWithRecycle";

  @override
  State<HybridCompositionWithRecycleViewWidget> createState() =>
      _HybridCompositionWithRecycleViewWidgetState();
}

class _HybridCompositionWithRecycleViewWidgetState extends State<HybridCompositionWithRecycleViewWidget> {
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
    const String viewType = "HybridCompositionWidget";
    // Pass parameters to the platform side.
    const Map<String, dynamic> creationParams = <String, dynamic>{"z":"k"};

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: PlatformViewLink(
            viewType: viewType,
            surfaceFactory: (context, controller) {
              return AndroidViewSurface(
                controller: controller as AndroidViewController,
                gestureRecognizers: const <Factory<
                    OneSequenceGestureRecognizer>>{},
                hitTestBehavior: PlatformViewHitTestBehavior.opaque,
              );
            },
            onCreatePlatformView: (params) {
              return PlatformViewsService.initSurfaceAndroidView(
                id: params.id,
                viewType: viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
                onFocus: () {
                  params.onFocusChanged(true);
                },
              )
                ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
                ..create();
            },
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
