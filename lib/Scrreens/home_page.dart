import 'package:flutter/material.dart';
import 'package:flutter_application_1/Scrreens/CardiologyDoctorsPage.dart';
import 'package:flutter_application_1/Scrreens/DentistsDoctorsPage.dart';
import 'package:flutter_application_1/Scrreens/Gynaelogy.dart';
import 'package:flutter_application_1/Scrreens/Chat_Page.dart';
import 'package:flutter_application_1/Scrreens/Date_Page.dart';
import 'package:flutter_application_1/Scrreens/Immunology_Doctors_Page.dart';
import 'package:flutter_application_1/Scrreens/Pathology_Doctors_Page.dart';
import 'package:flutter_application_1/Scrreens/Profile_Page.dart';
import 'package:flutter_application_1/Scrreens/LoginPage.dart';
import 'package:flutter_application_1/Scrreens/neurology_doctors_Page.dart';

class HomePage extends StatelessWidget {
  final String userName;

  HomePage({required this.userName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          '🩺 ~ Be Happy ~ 🩺',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    userName: userName,
                    email: 'johndoe@gmail.com',
                    appointmentHistory: [
                      Appointment(
                        doctorName: 'Dr. Smith',
                        specialty: 'Cardiology',
                        dateTime: '2023-10-01 10:30 AM',
                        status: 'Completed',
                      ),
                      Appointment(
                        doctorName: 'Dr. Johnson',
                        specialty: 'Neurology',
                        dateTime: '2023-09-20 12:00 PM',
                        status: 'Completed',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Upcoming Schedule Section
              Text(
                'Upcoming Schedule',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              SizedBox(height: 10),
              UpcomingScheduleCard(
                doctorName: 'Dr. Rashmika Sharma',
                specialty: 'Psychiatrist',
                dateTime: 'Jan 28, 12:25 am',
              ),
              UpcomingScheduleCard(
                doctorName: 'Dr. Mayank Prakash',
                specialty: 'Gynecologist',
                dateTime: 'Jan 18, 12:00 pm',
              ),
              SizedBox(height: 20),
              // Categories Section
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 10),
              CategoriesGrid(),
              SizedBox(height: 20),
              // Top Doctors Section
              Text(
                'Top Doctors',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 10),
              TopDoctorCard(
                doctorName: 'Dr. Rahul Sharma',
                specialty: 'Dental',
                ratings: 585,
              ),
              TopDoctorCard(
                doctorName: 'Dr. Monika Goyal',
                specialty: 'Surgeon',
                ratings: 698,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlueAccent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[300],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Date',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on Home, no action needed
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DatePage(),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}

class CategoriesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildCategoryCard(
          context,
          title: 'Pathology',
          icon: Icons.biotech,
          color: Color.fromARGB(255, 48, 128, 194)!,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PathologyDoctorsPage()),
            );
          },
        ),  
        _buildCategoryCard(
          context,
          title: 'Immunology',
          icon: Icons.science,
          color: Color.fromARGB(255, 141, 84, 246)!,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImmunologyDoctorsPage()),
            );
          },
        ),
        _buildCategoryCard(
          context,
          title: 'Gynaecology',
          icon: Icons.pregnant_woman,
          color: Color.fromARGB(255, 67, 113, 14)!,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Gynaecology()),
            );
          },
        ),
        _buildCategoryCard(
          context,
          title: 'Cardiology',
          icon: Icons.health_and_safety,
          color: const Color.fromARGB(255, 162, 101, 9)!,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CardiologyDoctorsPage()),
            );
          },
        ),
        _buildCategoryCard(
          context,
          title: 'Neurology',
          icon: Icons.psychology,
          color: const Color.fromARGB(255, 136, 123, 10)!,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NeurologyDoctorsPage()),
            );
          },
        ),
        _buildCategoryCard(
          context,
          title: 'Dentist',
          icon: Icons.health_and_safety,
          color: Color.fromARGB(255, 94, 92, 92)!,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DentistsDoctorsPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: color, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpcomingScheduleCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String dateTime;

  UpcomingScheduleCard({
    required this.doctorName,
    required this.specialty,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.blue[50],
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: Colors.blue),
        title: Text(doctorName),
        subtitle: Text('$specialty\n$dateTime'),
      ),
    );
  }
}

class TopDoctorCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final int ratings;

  TopDoctorCard({
    required this.doctorName,
    required this.specialty,
    required this.ratings,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.orange[50],
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.star, color: Colors.orange),
        title: Text(doctorName),
        subtitle: Text(specialty),
        trailing: Text('$ratings ratings'),
      ),
    );
  }
}
