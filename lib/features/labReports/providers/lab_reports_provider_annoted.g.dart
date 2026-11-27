// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_reports_provider_annoted.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myLabReports)
final myLabReportsProvider = MyLabReportsProvider._();

final class MyLabReportsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LabReportResponse>>,
          List<LabReportResponse>,
          FutureOr<List<LabReportResponse>>
        >
    with
        $FutureModifier<List<LabReportResponse>>,
        $FutureProvider<List<LabReportResponse>> {
  MyLabReportsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myLabReportsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myLabReportsHash();

  @$internal
  @override
  $FutureProviderElement<List<LabReportResponse>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LabReportResponse>> create(Ref ref) {
    return myLabReports(ref);
  }
}

String _$myLabReportsHash() => r'3c76883b401177dd4f8b9eda6262240b5e0557a6';

@ProviderFor(labReportById)
final labReportByIdProvider = LabReportByIdFamily._();

final class LabReportByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<LabReportResponse>,
          LabReportResponse,
          FutureOr<LabReportResponse>
        >
    with
        $FutureModifier<LabReportResponse>,
        $FutureProvider<LabReportResponse> {
  LabReportByIdProvider._({
    required LabReportByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'labReportByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$labReportByIdHash();

  @override
  String toString() {
    return r'labReportByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LabReportResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LabReportResponse> create(Ref ref) {
    final argument = this.argument as String;
    return labReportById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LabReportByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$labReportByIdHash() => r'93c09ee88aa8cc41848a7463255b9ccb7ab1a51b';

final class LabReportByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LabReportResponse>, String> {
  LabReportByIdFamily._()
    : super(
        retry: null,
        name: r'labReportByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LabReportByIdProvider call(String id) =>
      LabReportByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'labReportByIdProvider';
}

@ProviderFor(labReportsByAppointmentId)
final labReportsByAppointmentIdProvider = LabReportsByAppointmentIdFamily._();

final class LabReportsByAppointmentIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LabReportResponse>>,
          List<LabReportResponse>,
          FutureOr<List<LabReportResponse>>
        >
    with
        $FutureModifier<List<LabReportResponse>>,
        $FutureProvider<List<LabReportResponse>> {
  LabReportsByAppointmentIdProvider._({
    required LabReportsByAppointmentIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'labReportsByAppointmentIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$labReportsByAppointmentIdHash();

  @override
  String toString() {
    return r'labReportsByAppointmentIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<LabReportResponse>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LabReportResponse>> create(Ref ref) {
    final argument = this.argument as String;
    return labReportsByAppointmentId(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LabReportsByAppointmentIdProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$labReportsByAppointmentIdHash() =>
    r'18cdb9ed499cf1ae9c8412d4df881efbc94b5f06';

final class LabReportsByAppointmentIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<LabReportResponse>>, String> {
  LabReportsByAppointmentIdFamily._()
    : super(
        retry: null,
        name: r'labReportsByAppointmentIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LabReportsByAppointmentIdProvider call(String appointmentId) =>
      LabReportsByAppointmentIdProvider._(argument: appointmentId, from: this);

  @override
  String toString() => r'labReportsByAppointmentIdProvider';
}

@ProviderFor(CreateLabReport)
final createLabReportProvider = CreateLabReportProvider._();

final class CreateLabReportProvider
    extends $AsyncNotifierProvider<CreateLabReport, LabReportResponse?> {
  CreateLabReportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createLabReportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createLabReportHash();

  @$internal
  @override
  CreateLabReport create() => CreateLabReport();
}

String _$createLabReportHash() => r'bece6d726e3ccaa6b22321078ff22e9d2b59b800';

abstract class _$CreateLabReport extends $AsyncNotifier<LabReportResponse?> {
  FutureOr<LabReportResponse?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<LabReportResponse?>, LabReportResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LabReportResponse?>, LabReportResponse?>,
              AsyncValue<LabReportResponse?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
