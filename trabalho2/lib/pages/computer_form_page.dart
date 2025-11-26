import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/computer_model.dart';
import '../database/database_helper.dart';

const List<String> osOptions = ['Windows', 'Linux'];
const List<String> storageOptions = ['SSD', 'HD', 'Ambos'];

class ComputerFormPage extends StatefulWidget {
  final Computer? computer;

  const ComputerFormPage({super.key, this.computer});

  @override
  State<ComputerFormPage> createState() => _ComputerFormPageState();
}

class _ComputerFormPageState extends State<ComputerFormPage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _processorController = TextEditingController();
  final TextEditingController _ramController = TextEditingController();
  final TextEditingController _gpuController = TextEditingController();
  final TextEditingController _powerSupplyController = TextEditingController();
  final TextEditingController _caseModelController = TextEditingController();
  final TextEditingController _motherboardController = TextEditingController();
  final TextEditingController _ssdCountController = TextEditingController();
  final TextEditingController _hdCountController = TextEditingController();

  String _selectedOS = osOptions.first;
  String _selectedStorageType = storageOptions.first;
  
  File? _pickedImage; 
  String? _savedImagePath;

  @override
  void initState() {
    super.initState();
    if (widget.computer != null) {
      _nameController.text = widget.computer!.name;
      _processorController.text = widget.computer!.processor;
      _ramController.text = widget.computer!.ram;
      _gpuController.text = widget.computer!.gpu;
      
      _powerSupplyController.text = widget.computer!.powerSupply ?? '';
      _caseModelController.text = widget.computer!.caseModel ?? '';
      _motherboardController.text = widget.computer!.motherboard ?? '';
      
      _ssdCountController.text = widget.computer!.ssdCount.toString();
      _hdCountController.text = widget.computer!.hdCount.toString();
      
      _selectedOS = osOptions.firstWhere(
        (opt) => widget.computer!.operatingSystem.contains(opt),
        orElse: () => osOptions.first,
      );
      _selectedStorageType = storageOptions.firstWhere(
        (opt) => widget.computer!.storageType.contains(opt),
        orElse: () => storageOptions.first,
      );
      
      if (widget.computer!.imagePath != null && widget.computer!.imagePath!.isNotEmpty) {
        final existingFile = File(widget.computer!.imagePath!);
        if (existingFile.existsSync()) {
          _pickedImage = existingFile;
          _savedImagePath = widget.computer!.imagePath;
        } else {
          _savedImagePath = null; 
        }
      }
    } else {
      _ssdCountController.text = '1';
      _hdCountController.text = '0';
    }
  }

  Future<String?> _saveImagePermanently(File image) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(image.path)}';
      
      final savedImage = await image.copy('${appDir.path}/$fileName');
      return savedImage.path;
    } catch (e) {
      return null;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        _savedImagePath = null;
      });
    }
  }

  void _saveComputer() async {
    if (!_formKey.currentState!.validate()) { 
      return; 
    }
    
    final bool isSsdVisible = _selectedStorageType == 'SSD' || _selectedStorageType == 'Ambos';
    final bool isHdVisible = _selectedStorageType == 'HD' || _selectedStorageType == 'Ambos';
    
    final int ssdCount = isSsdVisible ? (int.tryParse(_ssdCountController.text) ?? 0) : 0;
    final int hdCount = isHdVisible ? (int.tryParse(_hdCountController.text) ?? 0) : 0;

    if (ssdCount + hdCount < 1) {
      _showMessage('O computador deve ter pelo menos 1 SSD ou 1 HD.');
      return;
    }

    final bool isCompleteStatus = _caseModelController.text.isNotEmpty && 
                                  _motherboardController.text.isNotEmpty &&
                                  _powerSupplyController.text.isNotEmpty;
                                    
    String? finalImagePath = _savedImagePath; 
    
    if (_pickedImage != null && _savedImagePath == null) {
      finalImagePath = await _saveImagePermanently(_pickedImage!);
    } else if (_pickedImage == null) {
      finalImagePath = null; 
    }

    final newComputer = Computer(
      id: widget.computer?.id,
      name: _nameController.text,
      processor: _processorController.text,
      ram: _ramController.text,
      gpu: _gpuController.text,
      
      powerSupply: _powerSupplyController.text.isEmpty ? null : _powerSupplyController.text,
      caseModel: _caseModelController.text.isEmpty ? null : _caseModelController.text,
      motherboard: _motherboardController.text.isEmpty ? null : _motherboardController.text,
      
      operatingSystem: _selectedOS,
      storageType: _selectedStorageType,
      ssdCount: ssdCount,
      hdCount: hdCount,
      imagePath: finalImagePath,
      isComplete: isCompleteStatus, 
    );

    if (widget.computer == null) {
      await _dbHelper.insertComputer(newComputer);
      _showMessage('Computador salvo com sucesso!');
    } else {
      await _dbHelper.updateComputer(newComputer);
      _showMessage('Computador atualizado com sucesso!');
    }

    if (mounted) {
      Navigator.pop(context, true); 
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _processorController.dispose();
    _ramController.dispose();
    _gpuController.dispose();
    _powerSupplyController.dispose();
    _caseModelController.dispose();
    _motherboardController.dispose();
    _ssdCountController.dispose();
    _hdCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.computer == null ? 'Adicionar Computador' : 'Editar Computador';
    final theme = Theme.of(context);

    final fieldsToCompleteBuild = [
      {'controller': _caseModelController, 'label': 'Gabinete (Obrigatório para Finalizar)', 'hint': 'Ex: Cooler Master'},
      {'controller': _motherboardController, 'label': 'Placa Mãe (Obrigatório para Finalizar)', 'hint': 'Ex: ASUS Z790'},
      {'controller': _powerSupplyController, 'label': 'Fonte (Obrigatório para Finalizar)', 'hint': 'Ex: 750W 80+ Gold'},
    ];


    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: _pickedImage != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(_pickedImage!, fit: BoxFit.cover, width: double.infinity, height: double.infinity)
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _pickedImage = null;
                                    _savedImagePath = null;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 50, color: Colors.grey[600]),
                            const Text('Adicionar Foto do PC', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              
              _buildTextField(_nameController, 'Nome do PC', 'Ex: Estação de Trabalho', 'Informe o nome do PC'),
              _buildTextField(_processorController, 'Processador', 'Ex: i7-13700K', 'Informe o Processador'),
              _buildTextField(_ramController, 'Memória RAM', 'Ex: 32GB DDR5', 'Informe a RAM'),
              _buildTextField(_gpuController, 'Placa de Vídeo', 'Ex: RTX 4070', 'Informe a GPU'),
              const SizedBox(height: 20),
              
              ...fieldsToCompleteBuild.map((f) => _buildOptionalTextField(
                f['controller'] as TextEditingController, f['label'] as String, f['hint'] as String)
              ).toList(),
              
              const SizedBox(height: 20),

              _buildDropdownField('Sistema Operacional', _selectedOS, osOptions, (String? newValue) {
                setState(() {
                  _selectedOS = newValue!;
                });
              }),
              const SizedBox(height: 20),

              _buildDropdownField('Tipo de Armazenamento', _selectedStorageType, storageOptions, (String? newValue) {
                setState(() {
                  _selectedStorageType = newValue!;
                });
              }),
              const SizedBox(height: 20),

              if (_selectedStorageType == 'SSD' || _selectedStorageType == 'Ambos')
                _buildNumberField(_ssdCountController, 'Quantidade de SSDs', '0', 'Informe a quantidade de SSDs'),

              if (_selectedStorageType == 'HD' || _selectedStorageType == 'Ambos')
                _buildNumberField(_hdCountController, 'Quantidade de HDs', '0', 'Informe a quantidade de HDs'),
              
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _saveComputer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  widget.computer?.isComplete == false ? 'FINALIZAR RASCUNHO' : 'SALVAR/ATUALIZAR PC', 
                  style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, String validationMsg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationMsg;
          }
          return null;
        },
      ),
    );
  }
  
  Widget _buildOptionalTextField(TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
        validator: (value) => null, 
      ),
    );
  }

  Widget _buildNumberField(TextEditingController controller, String label, String hint, String validationMsg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return null;
          }
          if (int.tryParse(value) == null) {
            return 'Por favor, insira um número inteiro válido.';
          }
          if (int.parse(value) < 0) {
            return 'O valor deve ser 0 ou maior.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField(String label, String currentValue, List<String> items, Function(String?) onChanged) {
    String effectiveValue = items.firstWhere(
      (opt) => currentValue.contains(opt) || opt == currentValue,
      orElse: () => items.first,
    );

    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: effectiveValue, 
          isExpanded: true,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}