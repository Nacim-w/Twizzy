import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.r),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  backgroundImage: AssetImage('assets/images/avatar.jpg'),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "John Doe",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "johndoe@example.com",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 30.h),
              _buildProfileOption(
                icon: Icons.person,
                text: AppLocalizations.of(context)!.editinformation,
                onTap: () => Navigator.pushNamed(context, '/edit_profile'),
              ),
              _buildProfileOption(
                icon: Icons.lock,
                text: AppLocalizations.of(context)!.changepassword,
                onTap: () {},
              ),
              _buildProfileOption(
                icon: Icons.logout,
                text: AppLocalizations.of(context)!.logout,
                iconColor: Colors.redAccent,
                onTap: () => Navigator.pushReplacementNamed(context, '/login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color iconColor = Colors.blueAccent,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: iconColor, size: 28.r),
          title: Text(
            text,
            style: TextStyle(fontSize: 16.sp, color: Colors.black87),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 20.r, color: Colors.black45),
          onTap: onTap,
        ),
        Divider(),
      ],
    );
  }
}
