import 'package:flutter/material.dart';
import 'package:gdg_campus_connect/features/ai_generator/views/ai_generator_view.dart';
import 'package:gdg_campus_connect/features/chat/views/chat_channels_view.dart';
import 'package:gdg_campus_connect/features/chat/views/chat_screen_view.dart';
import 'package:gdg_campus_connect/features/navigation/navigation_view.dart';
import 'package:gdg_campus_connect/features/profile_detail/views/profile_detail_view.dart';
import 'package:gdg_campus_connect/features/projects/views/create_project_view.dart';
import 'package:gdg_campus_connect/features/projects/views/project_detail_view.dart';
import 'package:gdg_campus_connect/features/projects/views/projects_view.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/features/login/views/login_view.dart';
import 'package:gdg_campus_connect/features/home/views/home_view.dart';
import 'package:gdg_campus_connect/features/splash/splash_view.dart';
import 'package:gdg_campus_connect/features/edit_profile/views/edit_profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
    ),
    GetPage(
  name: _Paths.PROFILE_DETAIL,
  page: () => const ProfileDetailView(),
),
    GetPage(
  name: _Paths.NAVIGATION,
  page: () => const MainNavigationView(),
),
GetPage(
  name: _Paths.AI_GENERATOR,
  page: () => const AiGeneratorView(),
),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
    ),
    GetPage(
      name: _Paths.PROJECTS,
      page: () => const ProjectsView(),
    ),
    GetPage(
      name: _Paths.CREATE_PROJECT,
      page: () => const CreateProjectView(),
    ),
    GetPage(
      name: _Paths.PROJECT_DETAIL,
      page: () => const ProjectDetailView(),
    ),

    GetPage(
      name: _Paths.CHAT_CHANNELS,
      page: () => const ChatChannelsView(),
    ),
    GetPage(
      name: _Paths.CHAT_SCREEN,
      page: () => const ChatScreenView(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
    ),
  ];
}