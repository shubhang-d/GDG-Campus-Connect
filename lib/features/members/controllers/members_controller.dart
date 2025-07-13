import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/data/models/user_model.dart';
import 'package:gdg_campus_connect/app/data/providers/user_service.dart';

class MembersController extends GetxController {
  final UserService _userService = Get.put(UserService());

  final _allUsers = <UserModel>[].obs;
  final isLoading = true.obs;
  
  // Reactive variables for filtering
  final searchTerm = ''.obs;
  final selectedSkillFilter = ''.obs;
  
  // A set to store all unique skills available for filtering
  final availableSkills = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      _allUsers.value = await _userService.getAllUsers();
      _populateAvailableSkills();
    } finally {
      isLoading.value = false;
    }
  }

  void _populateAvailableSkills() {
    final allSkills = <String>{};
    for (var user in _allUsers) {
      allSkills.addAll(user.skills);
    }
    availableSkills.assignAll(allSkills.toList()..sort());
  }

  // A computed property that returns the filtered list based on state
  List<UserModel> get filteredUsers {
    List<UserModel> users = _allUsers;

    if (searchTerm.value.isNotEmpty) {
      users = users.where((user) =>
          user.displayName.toLowerCase().contains(searchTerm.value.toLowerCase())
      ).toList();
    }

    if (selectedSkillFilter.value.isNotEmpty) {
      users = users.where((user) =>
          user.skills.contains(selectedSkillFilter.value)
      ).toList();
    }

    return users;
  }
}