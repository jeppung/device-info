import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';

import 'package:flutter_nfc_compatibility/flutter_nfc_compatibility.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:open_settings/open_settings.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:synapsis_project/app/data/db/db_helper.dart';
import 'package:synapsis_project/app/data/models/user.dart';
import 'package:synapsis_project/app/routes/app_pages.dart';

class AuthController extends GetxController {
  late TextEditingController usernameC;
  late TextEditingController passwordC;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var isAvailable = false;

  var route = "".obs;

  @override
  void onInit() async {
    super.onInit();

    usernameC = TextEditingController();
    passwordC = TextEditingController();
  }

  Future login(String username, String password) async {
    final db = await DatabaseHelper().database;

    try {
      var data = await db!
          .query("users", where: "username = ?", whereArgs: [username]);

      User user = User.fromJson(data[0]);

      if (Crypt(user.password).match(password)) {
        final box = GetStorage();

        box.write('isAuthenticate', true);
        return Future.value(true);
      } else {
        return Future.error("Username or password is incorrect");
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future register(String username, String password) async {
    final db = await DatabaseHelper().database;

    final hashed = Crypt.sha256(password);

    try {
      await db!.insert(
        "users",
        User(username: username, password: hashed.toString()).toJson(),
      );

      final box = GetStorage();

      box.write('isAuthenticate', true);

      return Future.value(true);
    } catch (e) {
      usernameC.clear();
      passwordC.clear();
      return Future.error("Username not available");
    }
  }

  nfcLogin() async {
    var available = await FlutterNfcCompatibility.checkNFCAvailability();
    if (available == NFCAvailability.Enabled) {
      Get.dialog(AlertDialog(
        content: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/card.png',
                width: 120,
              ),
              const SizedBox(height: 15),
              Text("Scan your card"),
            ],
          ),
        ),
      )).then((_) => NfcManager.instance.stopSession());

      NfcManager.instance.startSession(
        onDiscovered: (tag) {
          final box = GetStorage();
          box.write('isAuthenticate', true);

          Get.snackbar("Success", "Login success!",
              duration: Duration(seconds: 1));
          Get.offAllNamed(Routes.HOME);

          return Future.value(true);
        },
      );
    } else if (available == NFCAvailability.Disabled) {
      OpenSettings.openNFCSetting();
    } else {
      Get.snackbar("Error", "NFC is not available on this device",
          duration: Duration(seconds: 1));
    }
  }

  void biometricLogin() async {
    final LocalAuthentication auth = LocalAuthentication();

    var isDeviceSupported = await auth.isDeviceSupported();
    if (isDeviceSupported) {
      try {
        final didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to login',
          options: const AuthenticationOptions(
            biometricOnly: true,
          ),
        );

        if (didAuthenticate) {
          final box = GetStorage();
          box.write('isAuthenticate', true);

          Get.snackbar("Success", "Login success!",
              duration: Duration(seconds: 1));
          Get.offAllNamed(Routes.HOME);
        }
      } catch (e) {
        Get.snackbar("Error", e.toString());
      }
    } else {
      Get.snackbar("Error", "Biometrics is not supported",
          duration: Duration(seconds: 1));
      return null;
    }
  }

  void qrLogin() {
    Get.dialog(AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: SizedBox(
        height: 300,
        width: 300,
        child: QRView(
          key: qrKey,
          onQRViewCreated: (qrC) {
            qrC.scannedDataStream.listen((event) {
              if (event.code.toString() != "") {
                qrC.pauseCamera();
                final box = GetStorage();
                box.write('isAuthenticate', true);

                Get.snackbar('Success', 'Login success!',
                    duration: Duration(seconds: 1));
                Get.offAllNamed(Routes.HOME);
              }
            });
          },
        ),
      ),
    ));
  }
}
