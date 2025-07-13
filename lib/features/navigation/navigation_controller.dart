import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  // .obs makes this variable reactive.
  // The UI will automatically update when its value changes.
  var selectedIndex = 0.obs;

  // Method to be called when a navigation item is tapped.
  void changePage(int index) {
    selectedIndex.value = index;
  }
}