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

  void _executeDelete(int id) async {
    await _dbHelper.deleteComputer(id);
    _refreshComputerList();
    _showMessage('Computador deletado com sucesso!');
  }
  
  void _confirmDelete(Computer computer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir o computador "${computer.name}"? Esta ação não pode ser desfeita.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Excluir'),
              onPressed: () {
                Navigator.of(context).pop();
                _executeDelete(computer.id!);
              },
            ),
          ],
        );
      },
    );
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
          borderRadius: BorderRadius.circular(10.0),
          child: Image.file(
            imageFile,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) =>
                Icon(Icons.desktop_windows, size: 50, color: theme.primaryColor),
          ),
        );
      }
    }

    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Icon(
        Icons.desktop_windows_rounded,
        size: 45,
        color: theme.primaryColor,
      ),
    );
  }

  Widget _buildComputerCard(Computer computer, ThemeData theme) {
    final isComplete = computer.isComplete;

    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: () => _navigateToForm(computer: computer),
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildComputerImage(computer, theme),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      computer.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: theme.primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'CPU: ${computer.processor}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      'RAM: ${computer.ram}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 5),
                    if (!isComplete)
                      Text(
                        'RASCUNHO: Falta Finalizar',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_note_rounded, color: theme.colorScheme.secondary, size: 28),
                    tooltip: 'Editar',
                    onPressed: () => _navigateToForm(computer: computer),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 28),
                    tooltip: 'Deletar',
                    onPressed: () => _confirmDelete(computer),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<String> statusFilterOptions = [
      'Todos os Status',
      'Completo',
      'Rascunho'
    ];

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
            return Center(
              child: Text('Erro ao carregar dados: ${snapshot.error}'),
            );
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
          final incompleteBuilds =
              allComputers.where((c) => c.isComplete == false).length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        theme,
                        'Total de Builds',
                        totalBuilds.toString(),
                        Icons.storage_rounded,
                        theme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildSummaryCard(
                        theme,
                        'Rascunhos',
                        incompleteBuilds.toString(),
                        Icons.warning_amber_rounded,
                        Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedStatusFilter,
                  decoration: const InputDecoration(
                    labelText: 'Filtrar por Status',
                    prefixIcon: Icon(Icons.filter_list_rounded),
                  ),
                  items: statusFilterOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: theme.textTheme.bodyLarge),
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
                    ? Center(
                        child: Text(
                          'Nenhum build encontrado com o filtro atual.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      )
                    : filteredComputers.isEmpty
                        ? Center(
                            child: Text(
                              'Nenhum computador cadastrado. Adicione um novo!',
                              style: theme.textTheme.bodyMedium,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 10.0),
                            itemCount: filteredComputers.length,
                            itemBuilder: (context, index) {
                              return _buildComputerCard(
                                  filteredComputers[index], theme);
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
        backgroundColor: theme.colorScheme.secondary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard(
      ThemeData theme, String title, String value, IconData icon, Color iconColor) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 14
                )),
                Icon(icon, color: iconColor, size: 28),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}