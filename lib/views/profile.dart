import 'package:flutter/material.dart';
import 'package:twizzy/main.dart';
import 'package:twizzy/views/blog.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => BlogScreen()),
            );
          },
          child: const Icon(Icons.arrow_forward, color: Colors.white, size: 28),
        ),
        appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blueAccent,
          elevation: 4,
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/avatar.jpg'),
                ),
                SizedBox(height: 16),
                Text(
                  "John Doe",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "johndoe@example.com",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.person, color: Colors.blueAccent),
                  title: Text("Edit Name"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.email, color: Colors.blueAccent),
                  title: Text("Edit Email"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.lock, color: Colors.blueAccent),
                  title: Text("Change Password"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.redAccent),
                  title: Text("Logout"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
