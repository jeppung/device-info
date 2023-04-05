import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:synapsis_project/app/modules/home/controllers/home_controller.dart';

class PageDView extends GetView<HomeController> {
  const PageDView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controller.imagePath.isEmpty
                  ? SizedBox.shrink()
                  : Expanded(
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Image.file(
                              File(controller.imagePath.value),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "GPS Coordinate",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.yellow),
                              ),
                              Text(
                                "lat: ${controller.cameraLat}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.yellow),
                              ),
                              Text(
                                "long: ${controller.cameraLong}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.yellow),
                              ),
                            ],
                          ),
                          Positioned(
                            right: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Magnetometer",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.yellow),
                                ),
                                Text(
                                  "x: ${controller.cameraMagnetometer.value.x}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.yellow),
                                ),
                                Text(
                                  "y: ${controller.cameraMagnetometer.value.y}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.yellow),
                                ),
                                Text(
                                  "z: ${controller.cameraMagnetometer.value.z}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.yellow),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 10,
                            child: Text(
                              DateFormat("d MMMM yyyy h:mm:ss")
                                  .format(controller.time.value),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.yellow),
                            ),
                          ),
                        ],
                      ),
                    ),
              ElevatedButton(
                onPressed: controller.cameraHandler,
                child: const Text("Camera"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
