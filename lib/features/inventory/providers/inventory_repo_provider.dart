import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/network_providers.dart';
import 'package:frontend/features/inventory/data/repo/inventory_repo.dart';

final inventoryRepoProvider = Provider((ref) {
  return InventoryRepository(apiClient: ref.watch(apiClientProvider));
});
