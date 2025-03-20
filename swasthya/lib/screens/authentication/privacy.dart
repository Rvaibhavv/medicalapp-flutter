import 'package:flutter/material.dart';
import 'package:swasthya/screens/authentication/choose.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white ,
      appBar: AppBar(
        title: const Text("🔒 Privacy Policy"),
      ),
      body: Padding(
        padding:const  EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Yo, here’s how we roll with your privacy. No shady business, promise. 😎",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "1️⃣ What We Collect (Spoiler: Not Much)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "We’re not here to steal your personal info. We’re just trying to make the app better, so we might collect some stuff like:\n"
                "🔍 Your app usage (for fixing bugs and making stuff cooler).\n"
                "📶 Your device info (but like, only if we absolutely need it)."
                " Don’t worry, we’re not spying on you. That’s creepy. 😳",
              ),
              const SizedBox(height: 10),
              const Text(
                "2️⃣ How We Use Your Info",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Your info helps us do things like:\n"
                "💡 Make the app run smoother and cooler for you.\n"
                "⚡ Fix bugs and improve features based on what you like (or don’t like).\n"
                "👀 Make sure we don’t mess up your experience. You’re VIP, fam.",
              ),
              const SizedBox(height: 10),
              const Text(
                "3️⃣ How We Protect Your Privacy",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "We’re not trying to get you in trouble. Your privacy is safe with us. We do our best to:\n"
                "🔒 Keep your data on lockdown.\n"
                "🚫 Never share your info with anyone (unless it’s a big deal, like the law telling us to)."
                " We’re not trying to expose you, promise.",
              ),
              const SizedBox(height: 10),
              const Text(
                "4️⃣ Cookies (Not the Delicious Kind)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "We might use cookies (but not the chocolate chip kind, sorry) to:\n"
                "🍪 Make the app run smoother for you.\n"
                "🍪 Track app usage so we know where to improve.\n"
                "Don’t worry, cookies are harmless unless you’re allergic to them. 🍪😅",
              ),
              const SizedBox(height: 10),
              const Text(
                "5️⃣ Your Rights",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "You got rights, fam! Here’s what you can do:\n"
                "✌️ Opt out of some tracking (if you’re not cool with it).\n"
                "🛑 Ask us to delete your data (we’re chill with that)."
                " We got you. Your privacy, your call.",
              ),
              const SizedBox(height: 10),
              const Text(
                "6️⃣ Changes to This Privacy Policy",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "We might change this policy from time to time (because things change, right?). We’ll let you know, don’t worry. We’re not trying to sneak anything past you. 👀",
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Choose(),
                      ), // Your home screen widget
                    );
                  },
                  child: const Text("Got It, I’m In!"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
