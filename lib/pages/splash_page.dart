import 'package:elavo/pages/homepage.dart';
import 'package:elavo/pages/login_page.dart';
import 'package:elavo/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _shakeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shakeAnimation;
  bool _showText = false; // Trigger for the app name

  @override
  void initState() {
    super.initState();

    // Fade-in controller for the icon
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    // Shake controller for the icon
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    // Start fade-in first
    _fadeController.forward().whenComplete(() {
      // After fade-in, start vibrating
      _shakeController.repeat(reverse: true);
    });

    // Show app name after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _showText = true;
      });
    });

    // Navigate after 3 seconds based on Supabase session
    Future.delayed(const Duration(seconds: 3), () async {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dish icon with fade-in + vibration
            FadeTransition(
              opacity: _fadeAnimation,
              child: AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
                child: const Icon(
                  Icons.restaurant,
                  size: 100,
                  color: Colors.yellow,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // App name with fade-in
            AnimatedOpacity(
              opacity: _showText ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: Text(
                'Elavo',
                style: AppWidget.boldfieldTextStyle(color: Colors.yellow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
