import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locate_me/controller/service/build_marker.dart';
import 'package:locate_me/controller/service/map_model.dart';
import 'package:locate_me/view/screen/detail_screen.dart';
import 'package:locate_me/view/screen/widgets/show_back_diologue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(mapModelProvider.notifier).getLocation(context);
  }

  @override
  Widget build(BuildContext context) {
    final mapModel = ref.watch(mapModelProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        showBackDialog(context);
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                if (mapModel.currentPosition != null)
                  googleMap(constraints, mapModel),
                googleMap(constraints, mapModel),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: constraints.maxWidth * 0.8,
                          padding: const EdgeInsets.all(18.0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 7,
                                backgroundColor: Colors.green,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(mapModel.currentAddress ?? "Loading....."),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              ref
                                  .read(mapModelProvider.notifier)
                                  .getLocation(context);
                            },
                            child: const Icon(
                              Icons.refresh,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                const BeveledRectangleBorder(side: BorderSide.none),
              ),
              backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 1, 147, 27),
              ),
            ),
            onPressed: () {
              if (mapModel.currentAddress != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return DetailScreen(
                        currentAddress: mapModel.currentAddress!);
                  }),
                );
              } else {
                ref.read(mapModelProvider.notifier).getLocation(context);
              }
            },
            child: const Text(
              "Continue",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  GoogleMap googleMap(BoxConstraints constraints, MapModel mapModel) {
    return GoogleMap(
      indoorViewEnabled: true,
      padding: EdgeInsets.only(
        top: constraints.maxHeight * 0.130,
        left: 15,
      ),
      markers: buildMarkers(mapModel),
      myLocationButtonEnabled: true,
      buildingsEnabled: true,
      mapType: MapType.normal,
      initialCameraPosition: const CameraPosition(
        target: LatLng(28.1992, 77.4512),
        zoom: 1.0,
      ),
      myLocationEnabled: true,
      onMapCreated: (controller) {
        mapModel.setMapController(controller);
        _animateToPosition(controller, mapModel.currentPosition!);
      },
    );
  }

  void _animateToPosition(GoogleMapController controller, LatLng position) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      controller.animateCamera(CameraUpdate.newLatLngZoom(position, 17.0));
    });
  }
}
