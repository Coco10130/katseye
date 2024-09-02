import 'package:eukay/pages/profile/mappers/profile_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileRepository {
  Future<ProfileModel> fetchProfile(String token);
  Future<bool> updateProfile(
    String id,
    String token,
    String userName,
    String email,
    String phoneNumber,
    XFile? imageFile,
  );
}
