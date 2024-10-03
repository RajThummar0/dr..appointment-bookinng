import 'package:flutter/material.dart';
import 'package:flutter_application_1/Scrreens/LoginPage.dart';
import 'package:flutter_application_1/Scrreens/Profile_Page.dart';
import 'package:flutter_application_1/Scrreens/chat_page.dart';
import 'package:flutter_application_1/Scrreens/date_page.dart';
import 'package:flutter_application_1/Scrreens/home_page.dart';
import 'package:flutter_application_1/Scrreens/immunology_doctors_page.dart';
import 'package:flutter_application_1/Scrreens/CardiologyDoctorsPage.dart';
import 'package:flutter_application_1/Scrreens/signUpPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue.shade700,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black87),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/HomePage': (context) => HomePage(userName: ''),
        '/ProfilePage': (context) => ProfilePage(
          userName: 'John Doe',
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
        '/DatePage': (context) =>  DatePage(),
        '/ChatPage': (context) =>  ChatPage(),
      },
    );
  }
  
  ProfilePage({required String userName, required String email, required List<Appointment> appointmentHistory}) {}
}

// Appointment model class definition
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