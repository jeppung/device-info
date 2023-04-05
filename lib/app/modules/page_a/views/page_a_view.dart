import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:synapsis_project/app/modules/home/controllers/home_controller.dart';
import 'package:battery_info/battery_info_plugin.dart';

class PageAView extends GetView<HomeController> {
  PageAView({Key? key}) : super(key: key);

  final deviceInfo = DeviceInfoPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(
                  () => Text(
                    DateFormat.jms().format(
                      DateTime.parse(
                        controller.time.toString(),
                      ),
                    ),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Obx(
                  () => Text(
                    DateFormat('d MMMM y').format(controller.time.value),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                    future: deviceInfo.androidInfo,
                    builder: (context, snapshot) {
                      return Obx(
                        () => Table(
                          columnWidths: {
                            0: FlexColumnWidth(1.5),
                            1: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              children: [
                                Text("Accelerometer"),
                                Text("""
                                Accelerometer Event
x: ${controller.data1.value.x.toStringAsFixed(2)}
y: ${controller.data1.value.y.toStringAsFixed(2)}
z: ${controller.data1.value.z.toStringAsFixed(2)}
                              """
                                    .trimLeft()),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text("Gyroscope"),
                                Text("""
                                Gyroscope Event
x: ${controller.data2.value.x.toStringAsFixed(2)}
y: ${controller.data2.value.y.toStringAsFixed(2)}
z: ${controller.data2.value.z.toStringAsFixed(2)}
                              """
                                    .trimLeft()),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text("Magnetometer"),
                                Text("""
                                Magnetometer Event
x: ${controller.data3.value.x.toStringAsFixed(2)}
y: ${controller.data3.value.y.toStringAsFixed(2)}
z: ${controller.data3.value.z.toStringAsFixed(2)}
                              """
                                    .trimLeft()),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text("GPS"),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Obx(
                                      () => controller.isClicked.value == true
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 75),
                                              child:
                                                  CircularProgressIndicator(),
                                              width: 2,
                                              height: 25,
                                            )
                                          : OutlinedButton(
                                              onPressed: () async {
                                                controller.isClicked.value =
                                                    true;
                                                try {
                                                  var position =
                                                      await controller
                                                          .determinePosition();
                                                  controller.lat.value =
                                                      position.latitude;

                                                  controller.long.value =
                                                      position.longitude;
                                                } catch (_) {
                                                  openAppSettings();
                                                }

                                                controller.isClicked.value =
                                                    false;
                                              },
                                              child: const Text("Get Location"),
                                            ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text("""
Latitude: ${controller.lat.value}
Longitude: ${controller.long.value}
""")
                                  ],
                                )
                              ],
                            ),
                            TableRow(
                              children: [
                                Text('Battery Level'),
                                FutureBuilder(
                                  future:
                                      BatteryInfoPlugin().androidBatteryInfo,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                          "${snapshot.data!.batteryLevel}%");
                                    } else {
                                      return Text("Waiting");
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
