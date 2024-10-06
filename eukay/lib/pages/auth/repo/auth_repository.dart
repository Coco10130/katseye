abstract class AuthRepository {
  Future<String> loginRequest(String email, String password);
  Future<String> registerRequest(
      String userName, String email, String password, String confirmPassword);
  Future<String?> sendOtp(String email);
  Future<bool> verifyOtp(String email, String otp, String otpHash);
  Future<bool> resetPassword(String newPassword, String confirmPassword,
      String email, bool otpVerified);
}
