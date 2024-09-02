abstract class AuthRepository {
  Future<String> loginRequest(String email, String password);
  Future<String> registerRequest(
      String userName, String email, String password, String confirmPassword);
}
