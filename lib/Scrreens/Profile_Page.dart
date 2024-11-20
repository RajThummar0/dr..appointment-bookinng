import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String email; // Kept for backend operations, not displayed
  final List<Appointment> appointmentHistory;

  ProfilePage({
    required this.userName,
    required this.email,
    required this.appointmentHistory, required String initialUserName, required String initialEmail,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = '';
  bool _isEditingName = false;
  final TextEditingController _nameController = TextEditingController();

  double _rating = 0.0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userName = widget.userName;
  }

  // Update user name in Firestore
  Future<void> _updateUserName(String newName) async {
    final CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      await users.doc(widget.email).set({'name': newName}, SetOptions(merge: true));
      setState(() {
        _userName = newName;
        _isEditingName = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update name: $e')),
      );
    }
  }

  // Submit review and rating to Firestore
  Future<void> _submitReview() async {
    if (_reviewController.text.isEmpty || _rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide a rating and review')),
      );
      return;
    }

    final CollectionReference reviews = FirebaseFirestore.instance.collection('reviews');

    try {
      await reviews.add({
        'userName': _userName,
        'review': _reviewController.text,
        'rating': _rating,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _reviewController.clear();
        _rating = 0.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submitted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(),
            SizedBox(height: 20),
            _buildAppointmentHistory(),
            SizedBox(height: 20),
            _buildReviewSection(),
          ],
        ),
      ),
    );
  }

  // Build User Info Section
  Widget _buildUserInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue.shade700,
              child: Text(
                _userName.isNotEmpty ? _userName[0].toUpperCase() : '?',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _isEditingName
                      ? TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Enter new name',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                if (_nameController.text.isNotEmpty) {
                                  _updateUserName(_nameController.text);
                                }
                              },
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _userName,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                setState(() {
                                  _isEditingName = true;
                                  _nameController.text = _userName;
                                });
                              },
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build Appointment History Section
  Widget _buildAppointmentHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appointment History',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Divider(),
        ...widget.appointmentHistory.map((appointment) => _buildAppointmentCard(appointment)),
      ],
    );
  }

  // Build Appointment Card
  Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctor: ${appointment.doctorName}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Specialty: ${appointment.specialty}'),
            Text('Date: ${appointment.dateTime}'),
          ],
        ),
      ),
    );
  }

  // Build Review Section
  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Submit a Review',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        RatingBar.builder(
          initialRating: 0.0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        ),
        SizedBox(height: 10),
        TextField(
          controller: _reviewController,
          decoration: InputDecoration(
            labelText: 'Write your review here',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          maxLines: 3,
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _submitReview,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
          ),
          child: Text('Submit Review'),
        ),
      ],
    );
  }
}

// Appointment Model
class Appointment {
  final String doctorName;
  final String specialty;
  final String dateTime;

  Appointment({
    required this.doctorName,
    required this.specialty,
    required this.dateTime, required String status, required String doctorId,
  });
}
