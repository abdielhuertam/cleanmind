import '../models/user_profile.dart';
import 'local_user_profile_repository.dart';

abstract class UserProfileRepository {
  Future<UserProfile?> getProfile();

  Future<void> saveProfile(UserProfile profile);

  Future<void> updateUsername(String username);

  Future<void> deleteProfile();
}

final UserProfileRepository
    userProfileRepository =
    LocalUserProfileRepository();