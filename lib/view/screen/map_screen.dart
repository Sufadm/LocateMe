import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locate_me/controller/service/build_marker.dart';
import 'package:locate_me/controller/service/map_model.dart';
import 'package:locate_me/view/screen/detail_screen.dart';
import 'package:locate_me/view/screen/widgets/show_back_diologue.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapModel = ref.watch(mapModelProvider);
    if (mapModel.currentPosition == null) {
      mapModel.getLocation();
    }

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
                  GoogleMap(
                    indoorViewEnabled: true,
                    padding: EdgeInsets.only(
                        top: constraints.maxHeight * 0.130, left: 15),
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
                  ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                              Consumer(
                                builder: (context, ref, _) {
                                  return Text(mapModel.currentAddress ??
                                      "Loading.....");
                                },
                              ),
                            ],
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DetailScreen(currentAddress: mapModel.currentAddress!);
                }));
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

  void _animateToPosition(GoogleMapController controller, LatLng position) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      controller.animateCamera(CameraUpdate.newLatLngZoom(position, 17.0));
    });
  }
}
