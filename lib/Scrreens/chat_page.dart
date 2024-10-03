import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // List to hold chat messages
  List<Map<String, String>> messages = [];

  // Controller to capture message input
  TextEditingController _messageController = TextEditingController();

  // Function to send a message
  void _sendMessage() {
    String text = _messageController.text;
    if (text.isNotEmpty) {
      setState(() {
        messages.add({"message": text, "sender": "user"});
        _messageController.clear();
      });

      // Simulate doctor's reply
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          messages.add({"message": "Doctor's response", "sender": "doctor"});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with Doctor"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index];
                bool isUser = message["sender"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft, // Aligning chat bubbles
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16), // Custom margin
                    padding: EdgeInsets.all(12), // Custom padding
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey.shade300, // Color
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isUser ? 12 : 0), // Conditional rounding
                        topRight: Radius.circular(isUser ? 0 : 12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Text(message["message"] ?? ""),
                  ),
                ); 
              },
            ),
          ),
          
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
               ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,    // Button text color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                onPressed: _sendMessage,
                child: Text('Send'),
              ),
              ],
              
            ),
          ),
        ],
      ),
    );
  }
}
