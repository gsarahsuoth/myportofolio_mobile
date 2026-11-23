import 'package:flutter/material.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _institution = '';
  String _degree = '';
  String _startYear = '';
  String _endYear = '';

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  Widget _textField({
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: initialValue,
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardType,
        decoration: _decoration(label, hint: hint),
        onChanged: onChanged,
        validator:
            validator ??
            (required
                ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter $label.';
                    }
                    return null;
                  }
                : null),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Education Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textField(
                label: 'Institution Name',
                initialValue: _institution,
                onChanged: (value) => _institution = value,
                hint: 'Universitas Indonesia',
                maxLength: 255,
                required: true,
              ),
              _textField(
                label: 'Degree',
                initialValue: _degree,
                onChanged: (value) => _degree = value,
                hint: 'Bachelor of Computer Science',
                maxLines: 3,
                required: true,
              ),
              _textField(
                label: 'Start Year',
                initialValue: _startYear,
                onChanged: (value) => _startYear = value,
                hint: '2025',
                keyboardType: TextInputType.number,
                required: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Start Year.';
                  }

                  if (int.tryParse(value.trim()) == null) {
                    return 'Start Year must be a valid number.';
                  }

                  return null;
                },
              ),
              _textField(
                label: 'End Year',
                initialValue: _endYear,
                onChanged: (value) => _endYear = value,
                hint: "2029 (Leave it blank if it's still on going)",
                keyboardType: TextInputType.number,
                validator: (value) {
                  final endYearText = value?.trim() ?? '';

                  if (endYearText.isEmpty) {
                    return null;
                  }

                  final endYear = int.tryParse(endYearText);

                  if (endYear == null) {
                    return 'End Year must be a valid number.';
                  }

                  final startYear = int.tryParse(_startYear.trim());

                  if (startYear != null && endYear < startYear) {
                    return 'End Year cannot be earlier than Start Year.';
                  }

                  return null;
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Education added successfully!'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Institution Name: $_institution'),
                                Text('Degree: $_degree'),
                                Text('Start Year: $_startYear'),
                                Text(
                                  'End Year: ${_endYear.isEmpty ? 'Ongoing' : _endYear}',
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
