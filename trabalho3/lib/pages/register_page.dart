import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });

      if (_passwordController.text != _confirmPasswordController.text) {
        _showMessage('As senhas não coincidem!');
        setState(() { _isLoading = false; });
        return;
      }

      try {
        await _authService.registerWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nicknameController.text.trim(),
        );
        
        if (!mounted) return;
        _showMessage('Cadastro realizado com sucesso! Bem-vindo(a)!');

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
        
      } catch (e) {
        _showMessage('Erro no cadastro: ${e.toString().split(':').last}');
      } finally {
        setState(() { _isLoading = false; });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 30),
              Text(
                'Cadastre-se para começar!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  prefixIcon: Icon(Icons.person_rounded),
                ),
                validator: (val) => val!.isEmpty ? 'Informe seu nickname' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_rounded),
                ),
                validator: (val) => val!.isEmpty ? 'Digite um email válido' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_rounded),
                ),
                validator: (val) => val!.length < 6 ? 'A senha deve ter 6+ caracteres' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmação de Senha',
                  prefixIcon: Icon(Icons.lock_open_rounded),
                ),
                validator: (val) => val!.isEmpty ? 'Confirme a senha' : null,
              ),
              const SizedBox(height: 30),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _register,
                      icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
                      label: Text('CADASTRAR', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}