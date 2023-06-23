import 'package:flutter/material.dart';
import 'package:animo/reuseWidgets.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _showForm = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform your desired action here (e.g., send an email)
      String name = _nameController.text;
      String email = _emailController.text;
      String phone = _phoneController.text;
      String subject = _subjectController.text;
      String message = _messageController.text;

      // Perform further processing or API call with the form data

      // Clear the form fields
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _subjectController.clear();
      _messageController.clear();

      // Show a success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Message sent successfully!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, 'Contact Page'),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Contact Information',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text('Phone: +31 (0)592 - 376376'),
                const Text('Email: info@animo.nl '),
                const Text('Address: Dr. A.F. Philipsweg 47'),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showForm = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: const Text(
                    'If you wish to leave feedback, click this',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                if (_showForm) ...[
                  const SizedBox(height: 16.0),
                  const Text(
                    'Contact Form',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            // Add additional email validation if required
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(labelText: 'Phone'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _subjectController,
                          decoration:
                              const InputDecoration(labelText: 'Subject'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a subject';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _messageController,
                          decoration: InputDecoration(labelText: 'Message'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a message';
                            }
                            return null;
                          },
                          maxLines: 4,
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
