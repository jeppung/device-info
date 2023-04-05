import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:synapsis_project/app/modules/home/controllers/home_controller.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:synapsis_project/app/modules/page_b/utils/android_data_map.dart';
import 'package:synapsis_project/app/modules/page_b/utils/get_codename.dart';

class PageBView extends GetView<HomeController> {
  const PageBView({Key? key}) : super(key: key);
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
                Text(
                  "SoC",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                  future: DeviceInfoPlugin().androidInfo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var test = toMap(snapshot.data!);

                      var test2 = test.entries.map((e) {
                        return e;
                      }).toList();

                      var sdk = test2.firstWhere(
                          (element) => element.key == "version.sdkInt");

                      return Table(
                        columnWidths: {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(child: Text("version code")),
                              TableCell(
                                child: Text(getCodename(sdk.value)),
                              )
                            ],
                          ),
                          ...List.generate(test2.length, (index) {
                            return TableRow(children: [
                              TableCell(
                                  child: Text(test2[index].key.toString())),
                              TableCell(
                                  child: Text(test2[index].value.toString())),
                            ]);
                          })
                        ],
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return Text("");
                    }
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  "Generate QR Code",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: controller.textC,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Input text here...",
                  ),
                  onChanged: (value) {
                    controller.textForQr.value = value;
                  },
                ),
                Obx(
                  () => Container(
                    alignment: Alignment.center,
                    child: QrImage(
                      data: controller.textForQr.value,
                      size: 200,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
