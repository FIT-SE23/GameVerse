import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gameverse/ui/publisher/view_model/publisher_viewmodel.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';

class GameRequestDialog extends StatefulWidget {
  const GameRequestDialog({super.key});

  @override
  State<GameRequestDialog> createState() => _GameRequestDialogState();
}

class _GameRequestDialogState extends State<GameRequestDialog> {
  final _formKey = GlobalKey<FormState>();
  final _gameNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _briefDescriptionController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _categoriesController = TextEditingController();
  final _priceController = TextEditingController();
  final _requestMessageController = TextEditingController();
  
  bool _isLoading = false;
  final List<String> _selectedBinaries = [];
  final List<String> _selectedMedia = [];
  final List<String> _selectedExes = [];
  String? _headerImagePath;

  final List<CategoryModel> _selectedCategories = [];
  List<CategoryModel> _availableCategories = [];

  @override
  void dispose() {
    _gameNameController.dispose();
    _descriptionController.dispose();
    _briefDescriptionController.dispose();
    _requirementsController.dispose();
    _categoriesController.dispose();
    _priceController.dispose();
    _requestMessageController.dispose();
    super.dispose();
  }

    @override
  void initState() {
    super.initState();
    // Load available categories
    _loadCategories();
  }
  
  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    
    try {
      final publisherViewModel = Provider.of<PublisherViewModel>(context, listen: false);
      if (publisherViewModel.categories.isNotEmpty) {
        _availableCategories = publisherViewModel.categories;
      } else {
        _availableCategories = await publisherViewModel.getCategories();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: 700,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.add_circle,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Request Game Publication',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Form fields
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Game name
                        TextFormField(
                          controller: _gameNameController,
                          decoration: const InputDecoration(
                            labelText: 'Game Name *',
                            hintText: 'Enter your game name',
                            prefixIcon: Icon(Icons.games),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a game name';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Brief description
                        TextFormField(
                          controller: _briefDescriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Brief Description *',
                            hintText: 'Short description (max 150 characters)',
                            prefixIcon: Icon(Icons.short_text),
                            border: OutlineInputBorder(),
                          ),
                          maxLength: 150,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a brief description';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Full description
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Game Description *',
                            hintText: 'Detailed description of your game',
                            prefixIcon: Icon(Icons.description),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a game description';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // System requirements
                        TextFormField(
                          controller: _requirementsController,
                          decoration: const InputDecoration(
                            labelText: 'System Requirements *',
                            hintText: 'e.g., Windows 10, 4GB RAM, DirectX 11',
                            prefixIcon: Icon(Icons.computer),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter system requirements';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Categories
                        Text(
                          'Categories',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        
                        // Category selection chips
                        if (_availableCategories.isEmpty && !_isLoading)
                          Text(
                            'No categories available',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          )
                        else
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: _availableCategories.map((category) {
                              final isSelected = _selectedCategories.contains(category);
                              return FilterChip(
                                label: Text(category.name),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedCategories.add(category);
                                    } else {
                                      _selectedCategories.remove(category);
                                    }
                                  });
                                },
                                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                selectedColor: theme.colorScheme.primaryContainer,
                                checkmarkColor: theme.colorScheme.onPrimaryContainer,
                              );
                            }).toList(),
                          ),
                        
                        if (_selectedCategories.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Selected: ${_selectedCategories.map((e) => e.name).join(", ")}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        
                        // Validation message for categories
                        if (_selectedCategories.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Please select at least one category',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        
                        const SizedBox(height: 16),
                        
                        // Price
                        TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Price (VND) *',
                            hintText: '0.00 for free games',
                            prefixIcon: Icon(Icons.monetization_on),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price';
                            }
                            final price = double.tryParse(value);
                            if (price == null || price < 0) {
                              return 'Please enter a valid price';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Request message (optional)
                        TextFormField(
                          controller: _requestMessageController,
                          decoration: const InputDecoration(
                            labelText: 'Additional Message (Optional)',
                            hintText: 'Any additional information for the operators',
                            prefixIcon: Icon(Icons.message),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // File upload sections
                        _buildFileUploadSection(context),
                        
                        const SizedBox(height: 24),
                        
                        // Info section
                        _buildInfoSection(context),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Submit Request'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileUploadSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Game Files',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Header image
        _buildFilePickerTile(
          context,
          'Header Image',
          _headerImagePath != null ? [_headerImagePath!] : [],
          () => _pickHeaderImage(),
          Icons.image,
          'Select header image for your game',
        ),
        
        const SizedBox(height: 12),
        
        // Media files
        _buildFilePickerTile(
          context,
          'Media Files',
          _selectedMedia,
          () => _pickFiles('images'),
          Icons.photo_library,
          'Select screenshots, videos, and other media',
        ),

        const SizedBox(height: 12),

        // Binary files
        _buildFilePickerTile(
          context,
          'Game Binaries',
          _selectedBinaries,
          () => _pickFiles('binaries'),
          Icons.folder,
          'Select game executable and binary files',
        ),
        
        const SizedBox(height: 12),
        
        // Executable files
        _buildFilePickerTile(
          context,
          'Executable Files',
          _selectedExes,
          () => _pickFiles('exes'),
          Icons.play_arrow,
          'Select main executable files',
        ),
      ],
    );
  }

  Widget _buildFilePickerTile(
    BuildContext context,
    String title,
    List<String> files,
    VoidCallback onTap,
    IconData icon,
    String subtitle,
  ) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: files.isNotEmpty 
            ? Text('${files.length} file(s) selected')
            : Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (files.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    if (title == 'Header Image') {
                      _headerImagePath = null;
                    } else if (title == 'Game Binaries') {
                      _selectedBinaries.clear();
                    } else if (title == 'Media Files') {
                      _selectedMedia.clear();
                    } else if (title == 'Executable Files') {
                      _selectedExes.clear();
                    }
                  });
                },
              ),
            const Icon(Icons.upload_file),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info,
                color: theme.colorScheme.onPrimaryContainer,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Publication Process',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '1. Submit your game request with all required details\n'
            '2. Our operators will review your submission\n'
            '3. If approved, your game will be published\n'
            '4. You can track the status in your dashboard',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickHeaderImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _headerImagePath = result.files.first.path;
      });
    }
  }

  Future<void> _pickFiles(String type) async {
    FileType fileType;
    switch (type) {
      case 'images':
        fileType = FileType.image;
        break;
      case 'media':
        fileType = FileType.media;
        break;
      case 'exes':
        fileType = FileType.custom;
        break;
      default:
        fileType = FileType.any;
        break;
    }

    final result = await FilePicker.platform.pickFiles(
      type: fileType,
      allowMultiple: true,
      allowedExtensions: type == 'exes' ? ['exe', 'msi', 'dmg', 'deb'] : null,
    );

    if (result != null) {
      setState(() {
        final paths = result.paths.where((path) => path != null).cast<String>().toList();
        switch (type) {
          case 'images':
            _selectedMedia.addAll(paths);
            break;
          case 'binaries':
            _selectedBinaries.addAll(paths);
            break;
          case 'media':
            _selectedMedia.addAll(paths);
            break;
          case 'exes':
            _selectedExes.addAll(paths);
            break;
        }
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final publisherViewModel = Provider.of<PublisherViewModel>(context, listen: false);

      if (authViewModel.user == null) {
        throw Exception('User not authenticated');
      }
      if (_headerImagePath == null) {
        throw Exception('Header image is required');
      }
      if (_selectedMedia.isEmpty) {
        throw Exception('At least one media file is required');
      }
      if (_selectedBinaries.isEmpty) {
        throw Exception('At least one binary file is required');
      }
      if (_selectedExes.isEmpty) {
        throw Exception('At least one executable file is required');
      }

      final success = await publisherViewModel.requestGamePublication(
        publisherId: authViewModel.user!.id,
        gameName: _gameNameController.text.trim(),
        description: _descriptionController.text.trim(),
        briefDescription: _briefDescriptionController.text.trim(),
        requirements: _requirementsController.text.trim(),
        categories: _selectedCategories,
        price: double.parse(_priceController.text),
        binaries: _selectedBinaries,
        media: _selectedMedia,
        exes:  _selectedExes,
        headerImage: _headerImagePath!,
        requestMessage: _requestMessageController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Game publication request submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(publisherViewModel.errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}