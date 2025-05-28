// lib/utils/constants.dart
const String appVariant = String.fromEnvironment('APP_VARIANT', defaultValue: 'normal');
const bool isRootAppBuild = appVariant == 'root';

// You can add other app-wide constants here