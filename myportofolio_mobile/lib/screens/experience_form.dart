import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

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
  bool _isSubmitting = false;

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

  Future<void> _showSuccessDialog(Experience experience) async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Experience added successfully!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Experience Name: ${experience.title}'),
              Text('Description: ${experience.description}'),
              Text('Category: ${experience.category}'),
              Text('Thumbnail: ${experience.thumbnail}'),
              Text('Start Month: ${experience.startMonth}'),
              Text('Start Year: ${experience.startYear}'),
              Text('End Month: ${experience.endMonth}'),
              Text('End Year: ${experience.endYear}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(dialogContext),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(int statusCode) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Failed to add experience ($statusCode).')),
      );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthState>();
    final apiClient = context.read<ApiClient>();

    var allowed = await ensureLoggedIn(context);
    if (!mounted || !allowed) return;

    var token = authState.token;
    if (token == null) return;

    final newExperience = Experience(
      title: _title.trim(),
      description: _description.trim(),
      category: _category ?? _categories.first,
      thumbnail: _thumbnail.trim(),
      startMonth: _startMonth.trim(),
      startYear: _startYear.trim(),
      endMonth: _endMonth.trim(),
      endYear: _endYear.trim(),
    );

    setState(() => _isSubmitting = true);

    try {
      await apiClient.createExperience(newExperience, token: token);
      if (!mounted) return;
      await _showSuccessDialog(newExperience);
    } on ApiException catch (e) {
      if (!mounted) return;

      if (e.statusCode == 401) {
        await authState.logout();
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Session expired. Please log in again.'),
            ),
          );

        allowed = await ensureLoggedIn(context);
        if (!mounted || !allowed) return;

        token = authState.token;
        if (token == null) return;

        try {
          await apiClient.createExperience(newExperience, token: token);
          if (!mounted) return;
          await _showSuccessDialog(newExperience);
        } on ApiException catch (retryError) {
          _showErrorSnackBar(retryError.statusCode);
        }
      } else {
        _showErrorSnackBar(e.statusCode);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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
                  initialValue: _category,
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
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
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
