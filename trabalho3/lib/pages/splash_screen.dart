import 'package:flutter/material.dart';
import 'home_page.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), () {
      _checkAuthStatus();
    });
  }

  void _checkAuthStatus() {
    if (!mounted) return;

    _authService.user.listen((User? user) {
      if (user == null) {
        _navigateTo(const LoginPage());
      } else {
        _navigateTo(const HomePage());
      }
    }).asFuture(); 
  }

  void _navigateTo(Widget targetPage) {
    if (!mounted) return;
    
    _animationController.dispose(); 
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: Image.asset(
                    'assets/PC.png',
                    width: 150,
                    height: 150,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'PC Build Tracker',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.white, 
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}