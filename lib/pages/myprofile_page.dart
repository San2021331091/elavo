import 'package:elavo/pages/login_page.dart';
import 'package:elavo/pages/myrecipe_page.dart';
import 'package:elavo/services/supabase_auth.dart';
import 'package:elavo/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyProfilePage extends StatelessWidget {
  final User? user;
  final String? email;
  final String? avatarUrl;

  const MyProfilePage({super.key, this.user, this.email, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient AppBar using flexibleSpace
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: AppWidget.boldfieldTextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),

              // Avatar
              ClipOval(
                child: Image.network(
                  avatarUrl ?? '',
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 120,
                      width: 120,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      width: 120,
                      color: Colors.white24,
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),

              // Email
              Text(
                email!,
                style: AppWidget.boldfieldTextStyle(color: Colors.white),
              ),

              const SizedBox(height: 50),

              // Buttons
              GradientButton(
                text: "My Recipes",
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 207, 7, 77), Color.fromARGB(255, 203, 7, 7)],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyRecipePage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              GradientButton(
                text: "Logout",
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 187, 8, 77), Colors.red],
                ),
                onPressed: () async {
                  await SupabaseAuth.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> const LoginPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Gradient Button Widget
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Gradient gradient;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
