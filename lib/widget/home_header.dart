import 'package:elavo/pages/myprofile_page.dart';
import 'package:elavo/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    // Ensure email exists
    final email = (user?.email != null && user!.email!.isNotEmpty)
        ? user.email!
        : "default@example.com";

    // DiceBear avatar URL using 'avataaars' style for human-like appearance
    final avatarUrl =
        "https://api.dicebear.com/6.x/avataaars/png?seed=${Uri.encodeComponent(email)}";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 231, 5, 80), AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Looking for your\nfavorite food?",
              style: AppWidget.boldfieldTextStyle().copyWith(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          ClipOval(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MyProfilePage(user: user,email: email,avatarUrl: avatarUrl,)),
                );
              },
              child: Image.network(
                avatarUrl,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 60,
                    width: 60,
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
                    height: 60,
                    width: 60,
                    color: Colors.white24,
                    child: const Icon(Icons.person, color: Colors.white),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
