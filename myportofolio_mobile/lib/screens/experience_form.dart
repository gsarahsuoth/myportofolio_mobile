import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String? _category;
  String _thumbnail = '';
  String _startMonth = '';
  String _startYear = '';
  String _endMonth = '';
  String _endYear = '';

  final List<String> _categories = [
    'Internship',
    'Research',
    'Volunteer',
    'Part-time',
    'Full-time',
    'Freelance',
  ];

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
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
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: initialValue,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: _decoration(label, hint: hint),
        onChanged: onChanged,
        validator: required
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter $label.';
                }
                return null;
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Experience Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title
              _textField(
                label: 'Experience Name',
                initialValue: _title,
                onChanged: (value) => _title = value,
                required: true,
              ),

              // description
              _textField(
                label: 'Description',
                initialValue: _description,
                onChanged: (value) => _description = value,
                maxLines: 5,
                required: true,
              ),

              // category
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: _decoration('Category'),
                  value: _category,
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => _category = value);
                  },
                  validator: (value) =>
                      value == null ? 'Please select a category.' : null,
                ),
              ),

              // thumbnail
              _textField(
                label: 'Thumbnail',
                initialValue: _thumbnail,
                onChanged: (value) => _thumbnail = value,
                hint: 'Enter thumbnail URL',
                keyboardType: TextInputType.url,
              ),

              // start_month and start_year
              _textField(
                label: 'Start Month',
                initialValue: _startMonth,
                onChanged: (value) => _startMonth = value,
                hint: 'Example: January or 1',
                required: true,
              ),
              _textField(
                label: 'Start Year',
                initialValue: _startYear,
                onChanged: (value) => _startYear = value,
                hint: 'Example: 2025',
                keyboardType: TextInputType.number,
                required: true,
              ),

              // end_month and end_year
              _textField(
                label: 'End Month',
                initialValue: _endMonth,
                onChanged: (value) => _endMonth = value,
                hint: 'Leave blank if ongoing',
              ),
              _textField(
                label: 'End Year',
                initialValue: _endYear,
                onChanged: (value) => _endYear = value,
                hint: 'Leave blank if ongoing',
                keyboardType: TextInputType.number,
              ),

              // save button
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Experience added successfully!'),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Experience Name: $_title'),
                                  Text('Description: $_description'),
                                  Text('Category: $_category'),
                                  Text('Thumbnail: $_thumbnail'),
                                  Text('Start Month: $_startMonth'),
                                  Text('Start Year: $_startYear'),
                                  Text('End Month: $_endMonth'),
                                  Text('End Year: $_endYear'),
                                ],
                              ),
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
