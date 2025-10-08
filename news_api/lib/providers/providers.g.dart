// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$newsServiceHash() => r'e5f0e9f63f28d669efd8c982b934d76126551c3c';

/// See also [newsService].
@ProviderFor(newsService)
final newsServiceProvider = AutoDisposeProvider<NewsService>.internal(
  newsService,
  name: r'newsServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$newsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NewsServiceRef = AutoDisposeProviderRef<NewsService>;
String _$storiesHash() => r'b2da1617f40bacef256a769f8aae89ad32724e7d';

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

/// See also [stories].
@ProviderFor(stories)
const storiesProvider = StoriesFamily();

/// See also [stories].
class StoriesFamily extends Family<AsyncValue<List<NewsFormat>>> {
  /// See also [stories].
  const StoriesFamily();

  /// See also [stories].
  StoriesProvider call(
    StoryType type,
  ) {
    return StoriesProvider(
      type,
    );
  }

  @override
  StoriesProvider getProviderOverride(
    covariant StoriesProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'storiesProvider';
}

/// See also [stories].
class StoriesProvider extends AutoDisposeFutureProvider<List<NewsFormat>> {
  /// See also [stories].
  StoriesProvider(
    StoryType type,
  ) : this._internal(
          (ref) => stories(
            ref as StoriesRef,
            type,
          ),
          from: storiesProvider,
          name: r'storiesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storiesHash,
          dependencies: StoriesFamily._dependencies,
          allTransitiveDependencies: StoriesFamily._allTransitiveDependencies,
          type: type,
        );

  StoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final StoryType type;

  @override
  Override overrideWith(
    FutureOr<List<NewsFormat>> Function(StoriesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoriesProvider._internal(
        (ref) => create(ref as StoriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<NewsFormat>> createElement() {
    return _StoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoriesProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StoriesRef on AutoDisposeFutureProviderRef<List<NewsFormat>> {
  /// The parameter `type` of this provider.
  StoryType get type;
}

class _StoriesProviderElement
    extends AutoDisposeFutureProviderElement<List<NewsFormat>> with StoriesRef {
  _StoriesProviderElement(super.provider);

  @override
  StoryType get type => (origin as StoriesProvider).type;
}

String _$storyDetailHash() => r'c3fec0a5190719d071473ca455b929053fef4fb5';

/// See also [storyDetail].
@ProviderFor(storyDetail)
const storyDetailProvider = StoryDetailFamily();

/// See also [storyDetail].
class StoryDetailFamily extends Family<AsyncValue<NewsFormat>> {
  /// See also [storyDetail].
  const StoryDetailFamily();

  /// See also [storyDetail].
  StoryDetailProvider call(
    int id,
  ) {
    return StoryDetailProvider(
      id,
    );
  }

  @override
  StoryDetailProvider getProviderOverride(
    covariant StoryDetailProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'storyDetailProvider';
}

/// See also [storyDetail].
class StoryDetailProvider extends AutoDisposeFutureProvider<NewsFormat> {
  /// See also [storyDetail].
  StoryDetailProvider(
    int id,
  ) : this._internal(
          (ref) => storyDetail(
            ref as StoryDetailRef,
            id,
          ),
          from: storyDetailProvider,
          name: r'storyDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storyDetailHash,
          dependencies: StoryDetailFamily._dependencies,
          allTransitiveDependencies:
              StoryDetailFamily._allTransitiveDependencies,
          id: id,
        );

  StoryDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<NewsFormat> Function(StoryDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoryDetailProvider._internal(
        (ref) => create(ref as StoryDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<NewsFormat> createElement() {
    return _StoryDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoryDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StoryDetailRef on AutoDisposeFutureProviderRef<NewsFormat> {
  /// The parameter `id` of this provider.
  int get id;
}

class _StoryDetailProviderElement
    extends AutoDisposeFutureProviderElement<NewsFormat> with StoryDetailRef {
  _StoryDetailProviderElement(super.provider);

  @override
  int get id => (origin as StoryDetailProvider).id;
}

String _$commentsHash() => r'07eebdf2498425657ff187d8616404dab60c5acc';

/// See also [comments].
@ProviderFor(comments)
const commentsProvider = CommentsFamily();

/// See also [comments].
class CommentsFamily extends Family<AsyncValue<List<NewsFormat>>> {
  /// See also [comments].
  const CommentsFamily();

  /// See also [comments].
  CommentsProvider call(
    int storyId,
  ) {
    return CommentsProvider(
      storyId,
    );
  }

  @override
  CommentsProvider getProviderOverride(
    covariant CommentsProvider provider,
  ) {
    return call(
      provider.storyId,
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
  String? get name => r'commentsProvider';
}

/// See also [comments].
class CommentsProvider extends AutoDisposeFutureProvider<List<NewsFormat>> {
  /// See also [comments].
  CommentsProvider(
    int storyId,
  ) : this._internal(
          (ref) => comments(
            ref as CommentsRef,
            storyId,
          ),
          from: commentsProvider,
          name: r'commentsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$commentsHash,
          dependencies: CommentsFamily._dependencies,
          allTransitiveDependencies: CommentsFamily._allTransitiveDependencies,
          storyId: storyId,
        );

  CommentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storyId,
  }) : super.internal();

  final int storyId;

  @override
  Override overrideWith(
    FutureOr<List<NewsFormat>> Function(CommentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CommentsProvider._internal(
        (ref) => create(ref as CommentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storyId: storyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<NewsFormat>> createElement() {
    return _CommentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommentsProvider && other.storyId == storyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CommentsRef on AutoDisposeFutureProviderRef<List<NewsFormat>> {
  /// The parameter `storyId` of this provider.
  int get storyId;
}

class _CommentsProviderElement
    extends AutoDisposeFutureProviderElement<List<NewsFormat>>
    with CommentsRef {
  _CommentsProviderElement(super.provider);

  @override
  int get storyId => (origin as CommentsProvider).storyId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
