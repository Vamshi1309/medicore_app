// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_reports_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(labReportsRepo)
final labReportsRepoProvider = LabReportsRepoProvider._();

final class LabReportsRepoProvider
    extends
        $FunctionalProvider<
          LabReportsRepository,
          LabReportsRepository,
          LabReportsRepository
        >
    with $Provider<LabReportsRepository> {
  LabReportsRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'labReportsRepoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$labReportsRepoHash();

  @$internal
  @override
  $ProviderElement<LabReportsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LabReportsRepository create(Ref ref) {
    return labReportsRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LabReportsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LabReportsRepository>(value),
    );
  }
}

String _$labReportsRepoHash() => r'673697ddb598de121c229d07213bbc7946bcc722';
