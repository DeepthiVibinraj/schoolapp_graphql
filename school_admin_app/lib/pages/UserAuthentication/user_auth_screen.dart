import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_admin_app/core/constants/constants.dart';
import 'package:school_admin_app/pages/UserAuthentication/controllers/user_auth_controller.dart';

class UserAuthenticationScreen extends StatelessWidget {
  final UserAuthenticationController controller =
      Get.put(UserAuthenticationController());

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLogin = true.obs;
  final RxString userRole = 'parent'.obs; // Default role: parent

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLogin.value ? "Login" : "Signup",
                style: textTheme.headlineMedium,
              ),
              SizedBox(
                height: defaultPadding,
              ),
              if (!isLogin.value) ...[
                TextField(
                  controller: userNameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                const SizedBox(height: 10),
              ],
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (isLogin.value) {
                    controller.loginUser(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                  } else {
                    controller.signupUser(
                      userNameController.text.trim(),
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      'admin',
                    );
                  }
                },
                child: Obx(() => Text(isLogin.value ? "Login" : "Signup")),
              ),
              TextButton(
                onPressed: () {
                  isLogin.value = !isLogin.value;
                },
                child: Obx(
                  () => Text(isLogin.value
                      ? "Don't have an account? Signup"
                      : "Already have an account? Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
