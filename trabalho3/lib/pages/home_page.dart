import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import 'computer_list_page.dart';
import 'recommendation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  String _nickname = 'Usuário'; 

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    _nickname = currentUser?.displayName ?? 'Usuário';
  }

  void _logout() async {
    await _authService.signOut();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Widget targetPage,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: iconColor.withOpacity(0.3), width: 1.5), 
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(25.0), 
          child: Row(
            children: <Widget>[
              Icon(icon, size: 40, color: iconColor), 
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 18, color: theme.primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Principal', style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: _logout,
            tooltip: 'Sair da Conta',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Text(
                'Bem-vindo(a) de volta, $_nickname!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),
            
            _buildMenuItem(
              context,
              title: 'Meus PCs Cadastrados',
              subtitle: 'Gerencie e visualize seus builds salvos (CRUD Local).',
              icon: Icons.computer_rounded, 
              iconColor: theme.primaryColor,
              targetPage: const ComputerListPage(),
            ),
            const SizedBox(height: 25), 

            _buildMenuItem(
              context,
              title: 'Recomendações de Builds',
              subtitle: 'Sugestões para jogos, trabalho e renderização.',
              icon: Icons.auto_fix_high_rounded,
              iconColor: theme.colorScheme.secondary,
              targetPage: const RecommendationPage(),
            ),
        ],
      ),
    );
  }
}