import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _allergyController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();

  String? _selectedGender;
  List<String> _selectedDiets = [];

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _dietOptions = [
    'Vegetarian',
    'Vegan',
    'Halal',
    'Low Carb',
    'High Protein',
    'None',
  ];

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('age', _ageController.text);
    await prefs.setString('gender', _selectedGender ?? '');
    await prefs.setStringList('dietPreferences', _selectedDiets);
    await prefs.setString('allergies', _allergyController.text);
    await prefs.setStringList(
      'availableIngredients',
      _ingredientsController.text.split(',').map((e) => e.trim()).toList(),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile saved!')));
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _ageController.text = prefs.getString('age') ?? '';
      _selectedGender = prefs.getString('gender');
      _selectedDiets = prefs.getStringList('dietPreferences') ?? [];
      _allergyController.text = prefs.getString('allergies') ?? '';
      _ingredientsController.text =
          (prefs.getStringList('availableIngredients') ?? []).join(', ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Gender'),
                value: _selectedGender,
                items:
                    _genders.map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() => _selectedGender = value);
                },
              ),
              const SizedBox(height: 12),
              MultiSelectDialogField(
                title: const Text("Dietary Preferences"),
                buttonText: const Text("Select Dietary Preferences"),
                items:
                    _dietOptions
                        .map((diet) => MultiSelectItem(diet, diet))
                        .toList(),
                listType: MultiSelectListType.CHIP,
                initialValue: _selectedDiets,
                onConfirm: (values) {
                  setState(() {
                    _selectedDiets = values.cast<String>();
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _allergyController,
                decoration: const InputDecoration(
                  labelText: 'Any Allergies? (Optional)',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText:
                      'Available Ingredients (comma-separated, optional)',
                  hintText: 'e.g., chicken, rice, tomato',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
