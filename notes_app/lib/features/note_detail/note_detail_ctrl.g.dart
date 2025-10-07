// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_detail_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noteDetailControllerHash() =>
    r'8badf29974b3253138b14edcca02847346f0d10a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$NoteDetailController
    extends BuildlessAutoDisposeAsyncNotifier<Note?> {
  late final String? noteId;

  FutureOr<Note?> build(
    String? noteId,
  );
}

/// See also [NoteDetailController].
@ProviderFor(NoteDetailController)
const noteDetailControllerProvider = NoteDetailControllerFamily();

/// See also [NoteDetailController].
class NoteDetailControllerFamily extends Family<AsyncValue<Note?>> {
  /// See also [NoteDetailController].
  const NoteDetailControllerFamily();

  /// See also [NoteDetailController].
  NoteDetailControllerProvider call(
    String? noteId,
  ) {
    return NoteDetailControllerProvider(
      noteId,
    );
  }

  @override
  NoteDetailControllerProvider getProviderOverride(
    covariant NoteDetailControllerProvider provider,
  ) {
    return call(
      provider.noteId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'noteDetailControllerProvider';
}

/// See also [NoteDetailController].
class NoteDetailControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<NoteDetailController, Note?> {
  /// See also [NoteDetailController].
  NoteDetailControllerProvider(
    String? noteId,
  ) : this._internal(
          () => NoteDetailController()..noteId = noteId,
          from: noteDetailControllerProvider,
          name: r'noteDetailControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$noteDetailControllerHash,
          dependencies: NoteDetailControllerFamily._dependencies,
          allTransitiveDependencies:
              NoteDetailControllerFamily._allTransitiveDependencies,
          noteId: noteId,
        );

  NoteDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.noteId,
  }) : super.internal();

  final String? noteId;

  @override
  FutureOr<Note?> runNotifierBuild(
    covariant NoteDetailController notifier,
  ) {
    return notifier.build(
      noteId,
    );
  }

  @override
  Override overrideWith(NoteDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: NoteDetailControllerProvider._internal(
        () => create()..noteId = noteId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        noteId: noteId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<NoteDetailController, Note?>
      createElement() {
    return _NoteDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NoteDetailControllerProvider && other.noteId == noteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, noteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NoteDetailControllerRef on AutoDisposeAsyncNotifierProviderRef<Note?> {
  /// The parameter `noteId` of this provider.
  String? get noteId;
}

class _NoteDetailControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<NoteDetailController, Note?>
    with NoteDetailControllerRef {
  _NoteDetailControllerProviderElement(super.provider);

  @override
  String? get noteId => (origin as NoteDetailControllerProvider).noteId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
