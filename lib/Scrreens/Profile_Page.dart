import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userName;
  final String email;
  final List<Appointment> appointmentHistory;

  ProfilePage({
    required this.userName,
    required this.email,
    required this.appointmentHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    userName: userName,
                    email: email,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // User Avatar and Info
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/avatar.png'), // Replace with an actual image
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                userName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            Center(
              child: Text(
                email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 30),

            // Appointment History Section
            Text(
              'Appointment History',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: appointmentHistory.length,
              itemBuilder: (context, index) {
                final appointment = appointmentHistory[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      appointment.doctorName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    subtitle: Text('${appointment.specialty}\n${appointment.dateTime}'),
                    trailing: Text(
                      appointment.status,
                      style: TextStyle(
                        color: appointment.status == 'Completed' ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 30),

            // Payment Section (just for display)
            Text(
              'Payment Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('Total Paid:'),
                subtitle: Text('₹1500'), // Example amount
                trailing: Icon(Icons.payment, color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Edit Profile Page
class EditProfilePage extends StatefulWidget {
  final String userName;
  final String email;

  EditProfilePage({required this.userName, required this.email});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Handle the profile save action
                Navigator.pop(context, {
                  'userName': _nameController.text,
                  'email': _emailController.text,
                });
              },
              child: Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

// Appointment Model
class Appointment {
  final String doctorName;
  final String specialty;
  final String dateTime;
  final String status;

  Appointment({
    required this.doctorName,
    required this.specialty,
    required this.dateTime,
    required this.status,
  });
}
