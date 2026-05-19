import 'package:finetravel/data/mock_data.dart';
import 'package:finetravel/models/destination.dart';
import 'package:flutter/material.dart';

class AddPlaceDialog extends StatefulWidget {
  final VoidCallback onPlaceAdded;

  const AddPlaceDialog({super.key, required this.onPlaceAdded});

  @override
  State<AddPlaceDialog> createState() => _AddPlaceDialogState();
}

class _AddPlaceDialogState extends State<AddPlaceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _addPlace() {
    if (_formKey.currentState!.validate()) {
      final newDestination = Destination(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        location: _locationController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text.isNotEmpty 
            ? _imageUrlController.text 
            : 'https://images.unsplash.com/photo-1506929562872-bb421503ef21?q=80&w=1000', // Default image
        rating: 5.0, // Default rating for newly added
        price: '₺₺₺',
        latitude: null, // Could use current location, but keeping null for simplicity
        longitude: null,
        workingHours: '24/7 Open',
        entryFee: 'Free',
      );

      MockData.destinations.insert(0, newDestination); // Add to beginning so it appears first
      MockData.notifyDestinationsChanged();
      
      widget.onPlaceAdded();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Place added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a New Place'),
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Place Name',
                  hintText: 'e.g. Galata Tower',
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'e.g. Istanbul, Türkiye',
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a location' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Short description of the place...',
                ),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (optional)',
                  hintText: 'https://...',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _addPlace,
          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
          child: const Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
