import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final isLoading = true.obs;

  final RxList<Map<String, dynamic>> announcements = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> featuredProjects = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> upcomingEvents = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        fetchAnnouncements(),
        fetchFeaturedProjects(),
        fetchUpcomingEvents(),
      ]);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load home screen data: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAnnouncements() async {
    final snapshot = await _firestore
        .collection('announcements')
        .orderBy('timestamp', descending: true)
        .limit(3)
        .get();
    announcements.value = snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> fetchFeaturedProjects() async {
    final snapshot = await _firestore
        .collection('projects')
        .where('status', isEqualTo: 'Completed')
        .limit(5)
        .get();
    featuredProjects.value = snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> fetchUpcomingEvents() async {
    final snapshot = await _firestore
        .collection('events')
        .where('date', isGreaterThan: Timestamp.now())
        .orderBy('date')
        .limit(3)
        .get();
    upcomingEvents.value = snapshot.docs.map((doc) => doc.data()).toList();
  }
}