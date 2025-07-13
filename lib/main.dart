// Add this import
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/routes/app_pages.dart';
import 'package:gdg_campus_connect/app/controllers/auth_controller.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure Flutter engine is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // --- THIS IS THE NEW CODE TO ADD ---
  // Activate App Check for your app.
  // For debugging, we use the `AndroidProvider.debug` provider.
  await FirebaseAppCheck.instance.activate(
    // You can also use a `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // For android check the logs for the debug token and add it to the App Check console
    androidProvider: AndroidProvider.debug,
    // For apple check the logs for the debug token and add it to the App Check console
    appleProvider: AppleProvider.debug,
  );
  // ------------------------------------

  // Put AuthController into memory
  Get.put(AuthController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "GDG Campus Connect",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue[400],
      ),
    );
  }
}