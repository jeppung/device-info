import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:synapsis_project/app/modules/home/controllers/home_controller.dart';

class PageCView extends GetView<HomeController> {
  PageCView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
                child:
                    controller.lat.value != 0.0 && controller.long.value != 0.0
                        ? GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  controller.lat.value, controller.long.value),
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: MarkerId('test'),
                                position: LatLng(
                                  controller.lat.value,
                                  controller.long.value,
                                ),
                              )
                            },
                          )
                        : GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                controller.lat.value,
                                controller.long.value,
                              ),
                            ),
                          )),
          ],
        ),
      ),
    );
  }
}
