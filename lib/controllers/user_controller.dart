class UserController {
  String username = 'user123';
  String profileImageUrl = 'https://example.com/profile.jpg';

  void updateProfile(String newUsername, String newProfileImageUrl) {
    username = newUsername;
    profileImageUrl = newProfileImageUrl;
  }
}