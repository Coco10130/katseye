import 'package:eukay/pages/profile/mappers/address_model.dart';
import 'package:eukay/pages/profile/mappers/barangay_model.dart';
import 'package:eukay/pages/profile/mappers/municipality_model.dart';
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
  Future<List<MunicipalityModel>> fetchMunicipality();
  Future<List<BarangayModel>> fetchBarangays(String municipalityCode);
  Future<bool> addAddress(String token, String fullName, String municipality,
      String barangay, String contact, String street);
  Future<List<AddressModel>> fetchUserAddresses(String userId, String token);
}
