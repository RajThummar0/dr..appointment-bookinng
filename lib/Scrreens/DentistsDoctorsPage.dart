import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';// Firebase Auth for user ID

class DentistsDoctorsPage extends StatelessWidget {
  final List<Doctor> doctors = [
    Doctor(
      name: "Dr. Smita Joshi",
      specialty: "Dentistry",
      address: "1234 Dental Lane, Mumbai, Maharashtra",
      rating: 4.6,
      reviews: [
        "Dr. Smita is very gentle and caring. Highly recommend her!",
      ],
    ),
    Doctor(
      name: "Dr. Vikram Desai",
      specialty: "Oral Surgery",
      address: "5678 Smile Avenue, Pune, Maharashtra",
      rating: 4.9,
      reviews: [
        "Excellent service and very professional.",
      ],
    ),
    Doctor(
      name: "Dr. Riya Sharma",
      specialty: "Pediatric Dentistry",
      address: "9101 Kids Dental Road, Nashik, Maharashtra",
      rating: 4.8,
      reviews: [
        "Great with kids, made my daughter feel at ease.",
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dentists'),
        backgroundColor: Color.fromARGB(255, 173, 169, 169),
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

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onTap;

  DoctorCard({required this.doctor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
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
                doctor.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              Text(
                doctor.specialty,
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
              SizedBox(height: 8.0),
              Text(
                "Address: ${doctor.address}",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              SizedBox(height: 8.0),
              Text(
                "Rating: ${doctor.rating} ⭐",
                style: TextStyle(fontSize: 14, color: Colors.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

  void _confirmAppointment() async {
    if (_selectedDate != null && _selectedTime != null) {
      String formattedDate = _selectedDate!.toLocal().toString().split(' ')[0];
      String formattedTime = _selectedTime!.format(context);

      CollectionReference appointments =
          FirebaseFirestore.instance.collection('appointments');

      try {
        await appointments.add({
          'doctorName': widget.doctor.name,
          'doctorSpecialty': widget.doctor.specialty,
          'appointmentDate': formattedDate,
          'appointmentTime': formattedTime,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Appointment booked with ${widget.doctor.name} on $formattedDate at $formattedTime'),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to book appointment. Please try again.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select both date and time'),
        ),
      );
    }
  }
}
