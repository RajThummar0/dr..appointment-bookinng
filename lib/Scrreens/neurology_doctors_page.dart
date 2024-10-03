import 'package:flutter/material.dart';
import 'package:flutter_application_1/Scrreens/LoginPage.dart';
import 'package:flutter_application_1/Scrreens/chat_page.dart';
import 'package:flutter_application_1/Scrreens/date_page.dart';
import 'package:flutter_application_1/Scrreens/home_page.dart';
import 'package:flutter_application_1/Scrreens/immunology_doctors_page.dart';
import 'package:flutter_application_1/Scrreens/Profile_Page.dart';

class NeurologyDoctorsPage extends StatelessWidget {
  final List<Doctor> doctors = [
    Doctor(
      name: "Dr. Neha Sharma",
      specialty: "Neurology",
      address: "1234 Mind Lane, Mumbai, Maharashtra",
      rating: 4.6,
      reviews: [
        "Dr. Neha is very attentive and provides excellent care.",
      ],
    ),
    Doctor(
      name: "Dr. Rohan Mehta",
      specialty: "Clinical Neurology",
      address: "5678 Brainy Street, Pune, Maharashtra",
      rating: 4.9,
      reviews: [
        "He diagnosed my condition accurately and helped me feel better.",
      ],
    ),
    Doctor(
      name: "Dr. Priya Joshi",
      specialty: "Pediatric Neurology",
      address: "9101 Child Care Avenue, Nashik, Maharashtra",
      rating: 4.8,
      reviews: [
        "She is great with kids and explains everything clearly.",
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('neurology Doctors'),
        backgroundColor: Color.fromARGB(255, 169, 169, 61),
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return DoctorCard(
            doctor: doctors[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDetailPage(doctor: doctors[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Doctor {
  final String name;
  final String specialty;
  final String address;
  final double rating;
  final List<String> reviews;

  Doctor({
    required this.name,
    required this.specialty,
    required this.address,
    required this.rating,
    required this.reviews,
  });
}

class DoctorCard extends StatefulWidget {
  final Doctor doctor;
  final VoidCallback onTap;

  DoctorCard({required this.doctor, required this.onTap});

  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() {
          _isHovered = true;
        }),
        onExit: (_) => setState(() {
          _isHovered = false;
        }),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.yellowAccent.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 15,
                      offset: Offset(0, 0),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.yellowAccent.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doctor.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(
                  widget.doctor.specialty,
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                ),
                SizedBox(height: 8.0),
                Text(
                  "Address: ${widget.doctor.address}",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Text(
                      "Rating: ${widget.doctor.rating} ⭐",
                      style: TextStyle(fontSize: 14, color: Colors.orange),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.star, color: Colors.orange),
                  ],
                ),
                SizedBox(height: 8.0),
                Text("Reviews:", style: TextStyle(fontWeight: FontWeight.bold)),
                ...widget.doctor.reviews.map((review) => Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        "• $review",
                        style: TextStyle(color: Colors.black87),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// DoctorDetailPage remains the same as provided in the previous implementation
class DoctorDetailPage extends StatelessWidget {
  final Doctor doctor;

  DoctorDetailPage({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctor.name,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              doctor.specialty,
              style: TextStyle(fontSize: 20, color: Colors.blueGrey),
            ),
            SizedBox(height: 16.0),
            Text("Address: ${doctor.address}"),
            SizedBox(height: 8.0),
            Text("Rating: ${doctor.rating} ⭐"),
            SizedBox(height: 16.0),
            Text("Reviews:", style: TextStyle(fontWeight: FontWeight.bold)),
            ...doctor.reviews.map((review) => Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text("• $review"),
                )),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookAppointmentPage(doctor: doctor),
                    ),
                  );
                },
                child: Text('Book Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// BookAppointmentPage remains the same as provided in the previous implementation
class BookAppointmentPage extends StatefulWidget {
  final Doctor doctor;

  BookAppointmentPage({required this.doctor});

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment with ${widget.doctor.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectDate,
              child: Text(
                _selectedDate == null
                    ? 'Choose Date'
                    : _selectedDate!.toLocal().toString().split(' ')[0],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectTime,
              child: Text(
                _selectedTime == null
                    ? 'Choose Time'
                    : _selectedTime!.format(context),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _confirmAppointment,
                child: Text('Confirm Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _confirmAppointment() {
    if (_selectedDate != null && _selectedTime != null) {
      // Handle appointment confirmation logic here
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Appointment Confirmed!'),
            content: Text(
              'You have booked an appointment with ${widget.doctor.name} on ${_selectedDate!.toLocal().toString().split(' ')[0]} at ${_selectedTime!.format(context)}.',
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
