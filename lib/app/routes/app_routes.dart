part of 'app_pages.dart';

// Defines the names of the routes for type-safe navigation.
abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const HOME = _Paths.HOME;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const CHAT_CHANNELS = _Paths.CHAT_CHANNELS;
  static const CHAT_SCREEN = _Paths.CHAT_SCREEN;
  static const PROJECTS = _Paths.PROJECTS;
static const CREATE_PROJECT = _Paths.CREATE_PROJECT;
static const PROJECT_DETAIL = _Paths.PROJECT_DETAIL;
static const NAVIGATION = _Paths.NAVIGATION;
static const AI_GENERATOR = _Paths.AI_GENERATOR;
static const PROFILE_DETAIL = _Paths.PROFILE_DETAIL;

}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const EDIT_PROFILE = '/edit-profile';
  static const CHAT_CHANNELS = '/chat';
  static const CHAT_SCREEN = '/chat/screen';
  static const PROJECTS = '/projects';
static const CREATE_PROJECT = '/create-project';
static const NAVIGATION = '/navigation';
static const PROJECT_DETAIL = '/projects/:id'; 
static const AI_GENERATOR = '/ai-generator';
static const PROFILE_DETAIL = '/profile/:uid';
}