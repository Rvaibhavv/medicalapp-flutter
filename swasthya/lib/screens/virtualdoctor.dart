import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:swasthya/config.dart';
import 'mycolors.dart'; // Import MyColors

class VirtualDoctor extends StatefulWidget {
  const VirtualDoctor({super.key});

  @override
  _VirtualDoctorState createState() => _VirtualDoctorState();
}

class _VirtualDoctorState extends State<VirtualDoctor> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final String apiKey = AppConfig.Apigemini; // Replace with your actual API Key

  Future<void> sendMessage(String message) async {
    setState(() {
      _messages.add({"role": "user", "text": message});
    });

    String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": message}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        String fullReply = responseBody['candidates'][0]['content']['parts'][0]['text']
            .replaceAll('*', '') // Remove asterisks
            .trim();

        _simulateTypingEffect(fullReply);
      } else {
        setState(() {
          _messages.add({
            "role": "bot",
            "text": "Error fetching response. Code: ${response.statusCode}, Body: ${response.body}"
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"role": "bot", "text": "Error: $e"});
      });
    }
  }

  void _simulateTypingEffect(String fullReply) async {
    String displayedText = "";
    for (String word in fullReply.split(" ")) {
      displayedText += "$word ";
      setState(() {
        if (_messages.isNotEmpty && _messages.last["role"] == "bot") {
          _messages.last["text"] = displayedText;
        } else {
          _messages.add({"role": "bot", "text": displayedText});
        }
      });
      await Future.delayed(const Duration(milliseconds: 50)); // Adjust speed if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Light background for contrast
      appBar: AppBar(
        backgroundColor: MyColors.maincolor,
        elevation: 0,
        automaticallyImplyLeading: false,

        title: const Row(
          children: [
            Icon(Icons.medical_services, color: Colors.white), // AI Icon
            SizedBox(width: 10),
            Text("Virtual Doctor", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                final msg = _messages[index];
                bool isUser = msg["role"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7, // Messages won't touch opposite side
                    ),
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isUser ? MyColors.maincolor : MyColors.softTeal,
                      borderRadius: BorderRadius.only(
                        topLeft: isUser ? const Radius.circular(12) : Radius.zero,
                        topRight: isUser ? Radius.zero : const Radius.circular(12),
                        bottomLeft: const Radius.circular(12),
                        bottomRight: const Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 5), // Moves input box 5 pixels up
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 18),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Ask a medical question...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ClipOval(
                  child: Material(
                    color: MyColors.maincolor,
                    child: InkWell(
                      onTap: () {
                        if (_controller.text.isNotEmpty) {
                          sendMessage(_controller.text);
                          _controller.clear();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.send, color: Colors.white),
                      ),
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
