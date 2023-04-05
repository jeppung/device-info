import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

class HomeController extends GetxController {
  var time = DateTime.now().obs;
  var data1 = AccelerometerEvent(0, 0, 0).obs;
  var data2 = GyroscopeEvent(0, 0, 0).obs;
  var data3 = MagnetometerEvent(0, 0, 0).obs;
  var lat = 0.0.obs;
  var long = 0.0.obs;
  var isClicked = false.obs;
  var textForQr = "".obs;
  var imagePath = "".obs;
  var cameraLat = 0.0.obs;
  var cameraLong = 0.0.obs;
  var cameraMagnetometer = MagnetometerEvent(0, 0, 0).obs;
  var cameraTime = DateTime.now();

  late TextEditingController textC;

  @override
  void onInit() async {
    super.onInit();
    textC = TextEditingController();

    Timer.periodic(Duration(seconds: 1), (timer) {
      time.value = DateTime.now();
    });

    accelerometerEvents.listen((event) {
      data1.value = event;
    });

    gyroscopeEvents.listen((event) {
      data2.value = event;
    });

    magnetometerEvents.listen((event) {
      data3.value = event;
    });
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void cameraHandler() async {
    var locationPermission = await Permission.location.request();
    var cameraPermission = await Permission.camera.request();

    if (locationPermission.isGranted && cameraPermission.isGranted) {
      try {
        var subscription;

        var image = await ImagePicker().pickImage(source: ImageSource.camera);
        cameraTime = DateTime.now();

        if (image == null) {
          return null;
        }

        subscription = magnetometerEvents.listen((event) async {
          cameraMagnetometer.value = event;
          subscription.cancel();
        });

        var position = await determinePosition();

        cameraLat.value = position.latitude;
        cameraLong.value = position.longitude;

        imagePath.value = image.path;
      } on PlatformException catch (_) {
        openAppSettings();
      } catch (e) {
        Get.snackbar("Error", e.toString());
      }
    } else {
      if (locationPermission == PermissionStatus.permanentlyDenied ||
          cameraPermission == PermissionStatus.permanentlyDenied) {
        openAppSettings();
      }
    }
  }
}
