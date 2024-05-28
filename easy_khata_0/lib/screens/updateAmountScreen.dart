import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateAmountScreen extends StatefulWidget {
  static const String routeName = '/update_amount';
  final Map<String, dynamic> customer;

  const UpdateAmountScreen({Key? key, required this.customer}) : super(key: key);

  @override
  State<UpdateAmountScreen> createState() => _UpdateAmountScreenState();
}

class _UpdateAmountScreenState extends State<UpdateAmountScreen> {
  TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var customer = widget.customer;
    var email = customer['email'];
    var name = customer['name'];
    var amount = (customer['amount'] ?? 0).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Amount'),
        backgroundColor: Color(0xFF7AB2B2), // Use primary color from palette
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold), // Text color
            ),
            SizedBox(height: 8),
            Text(
              'Email: $email',
              style: TextStyle(color: Colors.black, fontSize: 16), // Text color
            ),
            SizedBox(height: 8),
            Text(
              'Current Amount: $amount',
              style: TextStyle(color: Colors.black, fontSize: 16), // Text color
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showAmountInputDialog(context, email, amount, true); // Add amount
                  },
                  child: const Text("I give", style: TextStyle(color: Colors.white)), // Adjusted text color
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4D869C), // Button color
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _showAmountInputDialog(context, email, amount, false); // Subtract amount
                  },
                  child: const Text("I got", style: TextStyle(color: Colors.white)), // Adjusted text color
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4D869C), // Button color
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      backgroundColor: Color(0xFFCDE8E5), // Background color
    );
  }

  void _showAmountInputDialog(BuildContext context, String email, double oldAmount, bool isAddition) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isAddition ? 'Add Amount' : 'Subtract Amount', style: TextStyle(color: Colors.black)), // Text color
          backgroundColor: Color(0xFF7AB2B2), // Background color
          content: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter amount",
              hintStyle: TextStyle(color: Colors.black), // Text color
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black), // Border color
              ),
            ),
            style: TextStyle(color: Colors.black), // Text color
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)), // Text color
            ),
            TextButton(
              onPressed: () {
                double amountToChange = double.tryParse(_amountController.text) ?? 0;
                updateAmount(email, amountToChange, oldAmount, isAddition: isAddition);
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Pop the dialog and the update amount screen
              },
              child: Text('OK', style: TextStyle(color: Colors.black)), // Text color
            ),
          ],
        );
      },
    );
  }

  Future<void> updateAmount(String email, double amountToChange, double oldAmount, {required bool isAddition}) async {
    double amount = isAddition ? oldAmount + amountToChange : oldAmount - amountToChange;
    try {
      await FirebaseFirestore.instance.collection('customers').doc(email).update({'amount': amount});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Amount updated successfully')));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update amount: $error')));
    }
  }
}
