import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:synapsis_project/app/routes/app_pages.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  AuthView({Key? key}) : super(key: key);

  GlobalKey<FormState> _regisFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/images/synapsis.png',
                      width: 100, height: 100),
                  const SizedBox(height: 10),
                  Text(
                    "Synapsis Project",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.usernameC,
                    autovalidateMode: AutovalidateMode.disabled,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please input username";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Username",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.passwordC,
                    autovalidateMode: AutovalidateMode.disabled,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please input password";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Password",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () async {
                        var isValid = _loginFormKey.currentState!.validate();

                        if (isValid) {
                          try {
                            await controller.login(controller.usernameC.text,
                                controller.passwordC.text);

                            Get.snackbar("Success", "Login success!",
                                duration: Duration(seconds: 1));
                            Get.offAllNamed(Routes.HOME);
                          } catch (e) {
                            Get.snackbar("Error", e.toString(),
                                duration: Duration(seconds: 1));
                          }
                        }
                      },
                      child: const Text("Login")),
                  const SizedBox(height: 20),
                  const Text(
                    "Or login with",
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: controller.nfcLogin,
                        icon: Icon(Icons.nfc_rounded),
                        splashRadius: 20,
                      ),
                      IconButton(
                        onPressed: controller.biometricLogin,
                        icon: Icon(
                          Icons.fingerprint,
                        ),
                        splashRadius: 20,
                      ),
                      IconButton(
                        onPressed: controller.qrLogin,
                        icon: Icon(
                          Icons.qr_code_2_rounded,
                        ),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                      ),
                      const SizedBox(width: 2),
                      GestureDetector(
                        onTap: () {
                          Get.dialog(AlertDialog(
                            content: Form(
                              key: _regisFormKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Register",
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    autovalidateMode: AutovalidateMode.disabled,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please input username";
                                      }
                                      return null;
                                    },
                                    controller: controller.usernameC,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "Username"),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    autovalidateMode: AutovalidateMode.disabled,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please input password";
                                      }
                                      return null;
                                    },
                                    controller: controller.passwordC,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "Password"),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () async {
                                      var isValid = _regisFormKey.currentState!
                                          .validate();

                                      if (isValid) {
                                        try {
                                          var register =
                                              await controller.register(
                                                  controller.usernameC.text,
                                                  controller.passwordC.text);
                                          if (register) {
                                            Get.snackbar(
                                                "Success", "Register Success!");
                                            Get.offAllNamed(Routes.HOME);
                                          }
                                        } catch (e) {
                                          Get.back();
                                          Get.snackbar("Error", e.toString());
                                        }
                                      }
                                    },
                                    child: const Text("Register"),
                                  )
                                ],
                              ),
                            ),
                          ));
                        },
                        child: Text(
                          "register here",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
