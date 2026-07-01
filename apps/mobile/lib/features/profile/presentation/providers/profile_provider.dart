import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/sample_data_service.dart';
import '../../../../core/providers/providers.dart';
import '../../data/models/profile_model.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    ref.watch(apiServiceProvider),
    ref.watch(storageServiceProvider),
  );
});

final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, ProfileEntity>(
  ProfileNotifier.new,
);

class ProfileNotifier extends AsyncNotifier<ProfileEntity> {
  @override
  Future<ProfileEntity> build() async {
    if (isLoadSampleData) {
      final json = await SampleDataService.getProfileData();
      final data = json['data'] as Map<String, dynamic>;
      return ProfileModel.fromJson(data).toEntity();
    }
    final repo = ref.read(profileRepositoryProvider);
    return repo.getProfile();
  }

  Future<void> updateProfile(ProfileEntity profile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(profileRepositoryProvider);
      return repo.updateProfile(profile);
    });
  }

  Future<void> uploadAvatar(String filePath) async {
    final repo = ref.read(profileRepositoryProvider);
    final url = await repo.uploadAvatar(filePath);
    final current = state.valueOrNull;
    if (current != null) {
      updateProfile(current.copyWith(avatar: url));
    }
  }

  Future<void> toggleBiometric(bool enabled) async {
    final repo = ref.read(profileRepositoryProvider);
    await repo.toggleBiometric(enabled);
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(biometricEnabled: enabled));
    }
  }

  Future<void> logout() async {
    final repo = ref.read(profileRepositoryProvider);
    await repo.logout();
  }
}
