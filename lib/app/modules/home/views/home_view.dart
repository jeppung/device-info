import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:synapsis_project/app/modules/page_a/views/page_a_view.dart';
import 'package:synapsis_project/app/modules/page_b/views/page_b_view.dart';
import 'package:synapsis_project/app/modules/page_c/views/page_c_view.dart';
import 'package:synapsis_project/app/modules/page_d/views/page_d_view.dart';
import 'package:synapsis_project/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Device Info'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                final box = GetStorage();
                box.write('isAuthenticate', false);

                Get.snackbar("Success", "Logout success!",
                    duration: Duration(seconds: 1));

                Get.offAllNamed(Routes.AUTH);
              },
              icon: Icon(Icons.logout),
            ),
          ],
          bottom: TabBar(tabs: [
            Tab(
              text: "A",
            ),
            Tab(
              text: "B",
            ),
            Tab(
              text: "C",
            ),
            Tab(
              text: "D",
            ),
          ]),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            PageAView(),
            PageBView(),
            PageCView(),
            PageDView(),
          ],
        ),
      ),
    );
  }
}
