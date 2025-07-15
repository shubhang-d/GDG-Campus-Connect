import 'package:flutter/material.dart';
import 'package:gdg_campus_connect/features/ai_generator/views/ai_generator_view.dart';
import 'package:gdg_campus_connect/features/global_chat/views/global_chat_view.dart';
import 'package:gdg_campus_connect/features/members/views/members_view.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/features/chat/views/chat_channels_view.dart';
import 'package:gdg_campus_connect/features/home/views/home_view.dart';
import 'package:gdg_campus_connect/features/navigation/navigation_controller.dart';
import 'package:gdg_campus_connect/features/projects/views/projects_view.dart';

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final MainNavigationController controller = Get.put(MainNavigationController());

    final List<Widget> screens = [
      const HomeView(),
      const ProjectsView(),
      const GlobalChatView(),
      const AiGeneratorView(),
      const MembersView(),
      const Scaffold(body: Center(child: Text("Members Screen"))),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: screens,
          )),
      
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changePage,
            
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,

            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.lightbulb_outline),
                activeIcon: Icon(Icons.lightbulb),
                label: 'Projects',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                activeIcon: Icon(Icons.chat_bubble),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_awesome_outlined),
                activeIcon: Icon(Icons.auto_awesome),
                label: 'AI Ideas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: 'Members',
              ),
            ],
          )),
    );
  }
}