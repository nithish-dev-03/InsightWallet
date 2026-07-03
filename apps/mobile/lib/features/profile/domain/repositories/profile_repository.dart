import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();
  Future<ProfileEntity?> getProfileByEmail(String email);
  Future<ProfileEntity> createProfile(ProfileEntity profile);
  Future<ProfileEntity> updateProfile(ProfileEntity profile);
  Future<String> uploadAvatar(String filePath);
  Future<void> toggleBiometric(bool enabled);
  Future<void> logout();
}
