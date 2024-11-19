import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  String selectedDoctor = "Dr. Smith"; // Default doctor for chat
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to send a message to Firestore
  void _sendMessage() async {
    String text = _messageController.text.trim();

    if (text.isNotEmpty) {
      _messageController.clear();

      // Save user's message in Firestore under selected doctor
      await _firestore
          .collection('chats')
          .doc(selectedDoctor)
          .collection('messages')
          .add({
        'message': text,
        'sender': 'user',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Optionally: Simulate a doctor's reply
      Future.delayed(Duration(seconds: 2), () {
        _sendDoctorReply();
      });
    }
  }

  // Simulate doctor's reply (In real app, this could come from an admin interface)
  void _sendDoctorReply() async {
    await _firestore
        .collection('chats')
        .doc(selectedDoctor)
        .collection('messages')
        .add({
      'message': "Doctor's reply goes here!",
      'sender': 'doctor',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with Doctor"),
        actions: [
          DropdownButton<String>(
            value: selectedDoctor,
            onChanged: (String? newDoctor) {
              setState(() {
                selectedDoctor = newDoctor!;
              });
            },
            items: ["Dr. Smith", "Dr. Johnson", "Dr. Sharma"].map((doctor) {
              return DropdownMenuItem<String>(
                value: doctor,
                child: Text(doctor),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Chat messages section
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(selectedDoctor)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true, // Show newest messages first
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var messageData =
                        messages[index].data() as Map<String, dynamic>;
                    bool isUser = messageData['sender'] == 'user';

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blue : Colors.grey.shade300,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(isUser ? 12 : 0),
                            topRight: Radius.circular(isUser ? 0 : 12),
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          messageData['message'] ?? "",
                          style: TextStyle(
                              color: isUser ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Message input field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text("Send"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
