import 'package:flutter/material.dart';
import 'dart:io';
import '../models/computer_model.dart';
import '../database/database_helper.dart';
import 'computer_form_page.dart';

class ComputerListPage extends StatefulWidget {
  const ComputerListPage({super.key});

  @override
  State<ComputerListPage> createState() => _ComputerListPageState();
}

class _ComputerListPageState extends State<ComputerListPage> {
  late Future<List<Computer>> _computerListFuture;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String _selectedStatusFilter = 'Todos os Status'; 

  @override
  void initState() {
    super.initState();
    _computerListFuture = _dbHelper.getComputers();
  }

  void _refreshComputerList() {
    setState(() {
      _computerListFuture = _dbHelper.getComputers();
    });
  }

  void _navigateToForm({Computer? computer}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComputerFormPage(computer: computer),
      ),
    );

    if (result == true) {
      _refreshComputerList();
    }
  }

  void _deleteComputer(int id) async {
    await _dbHelper.deleteComputer(id);
    _refreshComputerList();
    _showMessage('Computador deletado com sucesso!');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildComputerImage(Computer computer, ThemeData theme) {
    if (computer.imagePath != null && computer.imagePath!.isNotEmpty) {
      final imageFile = File(computer.imagePath!);

      if (imageFile.existsSync()) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(
            imageFile,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Icon(Icons.desktop_windows, size: 40, color: theme.primaryColor),
          ),
        );
      }
    }
    
    return Icon(
      Icons.desktop_windows, 
      size: 40, 
      color: theme.primaryColor,
    );
  }
  // -----------------------------------------------

  Widget _buildComputerCard(Computer computer, ThemeData theme) {
    final isComplete = computer.isComplete;

    return Card(
      elevation: 4, 
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: (computer.imagePath == null || computer.imagePath!.isEmpty) 
                ? theme.primaryColor.withOpacity(0.15) 
                : Colors.transparent,
          ),
          child: _buildComputerImage(computer, theme),
        ),
        
        title: Row(
          children: [
            Expanded(
              child: Text(
                computer.name,
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!isComplete)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.warning, color: Colors.amber, size: 20),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CPU: ${computer.processor} | RAM: ${computer.ram}',
                style: theme.textTheme.bodyMedium,
              ),
              if (!isComplete)
                Text(
                  'STATUS: FALTA FINALIZAR!',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red.shade700, fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ),
        
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.green),
              tooltip: 'Editar',
              onPressed: () => _navigateToForm(computer: computer),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Deletar',
              onPressed: () => _deleteComputer(computer.id!),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<String> statusFilterOptions = ['Todos os Status', 'Completo', 'Rascunho'];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Meus PCs Cadastrados'),
        elevation: 0,
      ),
      body: FutureBuilder<List<Computer>>(
        future: _computerListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Erro: Dados não disponíveis.'));
          }

          final allComputers = snapshot.data!;
          final filteredComputers = allComputers.where((computer) {
            if (_selectedStatusFilter == 'Completo') {
              return computer.isComplete == true;
            } else if (_selectedStatusFilter == 'Rascunho') {
              return computer.isComplete == false;
            }
            return true;
          }).toList();
          
          final totalBuilds = allComputers.length;
          final incompleteBuilds = allComputers.where((c) => c.isComplete == false).length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(child: _buildSummaryCard(
                      theme, 
                      'Total de Builds', 
                      totalBuilds.toString(), 
                      Icons.storage_rounded,
                      Colors.blueAccent
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: _buildSummaryCard(
                      theme, 
                      'Rascunhos', 
                      incompleteBuilds.toString(), 
                      Icons.warning_amber_rounded,
                      Colors.orange
                    )),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedStatusFilter,
                  decoration: InputDecoration(
                    labelText: 'Filtrar por Status',
                    prefixIcon: const Icon(Icons.filter_list),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  items: statusFilterOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedStatusFilter = newValue!;
                    });
                  },
                ),
              ),

              Expanded(
                child: filteredComputers.isEmpty && totalBuilds > 0
                  ? Center(child: Text('Nenhum build encontrado com o filtro atual.', style: theme.textTheme.bodyMedium))
                  : filteredComputers.isEmpty
                    ? Center(child: Text('Nenhum computador cadastrado. Adicione um novo!', style: theme.textTheme.bodyMedium))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0),
                        itemCount: filteredComputers.length,
                        itemBuilder: (context, index) {
                          return _buildComputerCard(filteredComputers[index], theme);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        tooltip: 'Adicionar Novo PC',
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildSummaryCard(ThemeData theme, String title, String value, IconData icon, Color iconColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: theme.textTheme.bodyMedium),
                Icon(icon, color: iconColor, size: 24),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 28, 
                color: theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}