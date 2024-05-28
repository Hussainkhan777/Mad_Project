import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCustomerScreen extends StatelessWidget {
  static const String routeName = '/add_customer';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF7AB2B2), // Same app bar color as the main screen
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.black), // Text color
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // Border color
                  ),
                ),
                style: TextStyle(color: Colors.black), // Text color
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black), // Text color
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // Border color
                  ),
                ),
                style: TextStyle(color: Colors.black), // Text color
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: Text('Add', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4D869C), // Same button color as the main screen
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFCDE8E5), // Same background color as the main screen
    );
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Get the user ID of the currently signed-in user
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        // Access the Firestore collection for storing customers
        final customerCollection = FirebaseFirestore.instance.collection('customers');

        // Use the email as the document ID
        final email = _emailController.text.trim();

        // Add the customer data to Firestore
        await customerCollection.doc(email).set({
          'name': _nameController.text.trim(),
          'email': email,
          'amount': 0,
        });

        // Navigate back to the previous screen (MainScreen)
        Navigator.of(context).pop();
      }
    }
  }
}
