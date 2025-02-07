import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:twizzy/services/api_service.dart';
import 'package:twizzy/models/user_model.dart'; // Ensure you have the User model

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String userId = "";  // Will be populated when the user is logged in

  @override
  void initState() {
    super.initState();
    // Fetch user data from the API or SharedPreferences
    _loadUserData();
  }

  // Fetch the user data (from API or SharedPreferences)
  Future<void> _loadUserData() async {
    try {
      // Here you would fetch the current user data (you can get it from an API or local storage)
      // Simulate fetching data
      // User currentUser = await ApiService.getUserProfile(); // Uncomment if API is available
      // For now, let's use mock data:
      User currentUser = User(id: "1", username: "ActualUsername", email: "actualuser@example.com", password: "");

      // Set the values to the controllers
      setState(() {
        userId = currentUser.id;
        usernameController.text = currentUser.username;
        emailController.text = currentUser.email;
      });
    } catch (e) {
      // Handle errors, such as network failure
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load user data")));
    }
  }

  Future<void> _saveChanges() async {
    String updatedUsername = usernameController.text.trim();
    String updatedEmail = emailController.text.trim();

    if (updatedUsername.isEmpty || updatedEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields")));
      return;
    }

    // Create the updated user object
    User updatedUser = User(
      id: userId,
      username: updatedUsername,
      email: updatedEmail,
      password: "", // Password is not being updated here, but it could be.
    );

    try {
      Map<String, dynamic> response = await ApiService.updateUser(userId, updatedUser);

      if (response.containsKey("message") && response["message"] == "User updated successfully!") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated successfully")));
        Navigator.pop(context); // Go back after successful update
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update profile")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.editprofile,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.r,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60.r,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: AssetImage("assets/images/avatar.jpg"),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                  padding: EdgeInsets.all(8.w),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 24.r),
                )
              ],
            ),
            SizedBox(height: 30.h),
            _buildInputField(AppLocalizations.of(context)!.username, usernameController),
            SizedBox(height: 20.h),
            _buildInputField(AppLocalizations.of(context)!.email, emailController),
            SizedBox(height: 30.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges, // Call _saveChanges when the user taps Save Changes
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.savechanges,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        SizedBox(height: 5.h),
        TextField(
          controller: controller,
          style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          decoration: InputDecoration(
            hintText: controller.text, // Display the current value in the hint
            hintStyle: TextStyle(color: Colors.black45, fontSize: 14.sp),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          ),
        ),
      ],
    );
  }
}
