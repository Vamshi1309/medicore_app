import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/network_providers.dart';
import 'package:frontend/features/patient/dashboard/data/repos/appointment_repository.dart';

final appointmentRepoProvider = Provider((ref) {
  return AppointmentRepository(apiClient: ref.watch(apiClientProvider));
});
