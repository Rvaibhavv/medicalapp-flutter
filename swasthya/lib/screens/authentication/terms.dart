import 'package:flutter/material.dart';
import 'package:swasthya/screens/authentication/choose.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("📜 Terms and Conditions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Yo, welcome to our super serious Terms and Conditions! Yeah, we know you ain’t gonna read this. 😂",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "1️⃣ You Agree to These Terms (Deal with It)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "By using this app, you’re saying ‘yeah, whatever’ to these terms.\n"
                "If you’re not down, your only options are:\n"
                "a) Bounce from the app like nothing ever happened.\n"
                "b) Keep using it, but don’t act like you read this. Ain’t nobody got time for that.",
              ),
              const SizedBox(height: 10),
              const Text(
                "2️⃣ What You’re Gonna Do",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "You agree to:\n"
                "✔️ Not blaming us when your phone dies at the worst time.\n"
                "✔️ Not using the app while you’re skydiving or fighting off a bear.\n"
                "✔️ Pretend you love the app and drop us a virtual high-five. 🙌",
              ),
              const SizedBox(height: 10),
              const Text(
                "3️⃣ Data? Nah, We’re Good",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "We ain’t stealing your data, chill. We might collect some good vibes or memes, though. That’s about it. 😎",
              ),
              const SizedBox(height: 10),
              const Text(
                "4️⃣ What Happens if Stuff Breaks",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "If the app crashes, it’s not on us. It’s your phone, fam. But if you drop it laughing at our jokes, we ain’t responsible, but we’ll send you a virtual hug. 😜",
              ),
              const SizedBox(height: 10),
              const Text(
                "5️⃣ We Can Ditch You",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "If you mess around with the app, disrespect snack breaks, or drop mad grammar mistakes (like ‘your’ vs ‘you’re’), we’re out. Peace. ✌️",
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const 
                        Choose(),
                      ), // Your next screen
                    );
                  },
                  child: const Text("I Agree (Yeah, I Totally Read This)"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
