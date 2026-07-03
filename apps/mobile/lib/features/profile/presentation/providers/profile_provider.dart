import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final profileProvider = AsyncNotifierProvider<ProfileNotifier, ProfileEntity>(
  ProfileNotifier.new,
);

final currencySymbolProvider = Provider<String>((ref) {
  final profile = ref.watch(profileProvider).valueOrNull;
  final currencyCode = profile?.currency ?? 'USD';
  switch (currencyCode.toUpperCase()) {
    case 'INR':
      return '₹';
    case 'EUR':
      return '€';
    case 'GBP':
      return '£';
    case 'JPY':
      return '¥';
    case 'AUD':
      return 'A\$';
    case 'CAD':
      return 'C\$';
    case 'USD':
    default:
      return '\$';
  }
});

class ProfileNotifier extends AsyncNotifier<ProfileEntity> {
  @override
  Future<ProfileEntity> build() async {
    try {
      final repo = ref.read(profileRepositoryProvider);
      final profile = await repo.getProfile();
      if (profile.name.trim().isNotEmpty) {
        return profile;
      }
      throw Exception('Profile is empty');
    } catch (e) {
      final json = await SampleDataService.getProfileData();
      final data = json['data'] as Map<String, dynamic>;
      return ProfileModel.fromJson(data).toEntity();
    }
  }

  Future<void> createProfile(ProfileEntity profile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(profileRepositoryProvider);
      return repo.createProfile(profile);
    });
  }

  Future<void> updateProfile(ProfileEntity profile) async {
    state = const AsyncLoading<ProfileEntity>().copyWithPrevious(state);
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
