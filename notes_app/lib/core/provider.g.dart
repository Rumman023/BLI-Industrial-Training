// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$databaseServiceHash() => r'766f41a8fb8947216fae68bbc31fa62d037f6899';

/// See also [databaseService].
@ProviderFor(databaseService)
final databaseServiceProvider = AutoDisposeProvider<DatabaseService>.internal(
  databaseService,
  name: r'databaseServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$databaseServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DatabaseServiceRef = AutoDisposeProviderRef<DatabaseService>;
String _$themeModeNotifierHash() => r'ec987fefee1674b50b86c1a10c29913745e6d87e';

/// See also [ThemeModeNotifier].
@ProviderFor(ThemeModeNotifier)
final themeModeNotifierProvider =
    AutoDisposeNotifierProvider<ThemeModeNotifier, ThemeMode>.internal(
  ThemeModeNotifier.new,
  name: r'themeModeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeModeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeModeNotifier = AutoDisposeNotifier<ThemeMode>;
String _$fontSizeNotifierHash() => r'c3412c68904838b82f5e324c912b410f29fad2ae';

/// See also [FontSizeNotifier].
@ProviderFor(FontSizeNotifier)
final fontSizeNotifierProvider =
    AutoDisposeNotifierProvider<FontSizeNotifier, double>.internal(
  FontSizeNotifier.new,
  name: r'fontSizeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fontSizeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FontSizeNotifier = AutoDisposeNotifier<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
