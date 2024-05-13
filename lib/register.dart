import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'shop/dashboard.dart';
import 'admin/dashboard.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _accountExistsError;

  // Define user types
  List<String> userTypes = ['Admin', 'Shop'];
  String selectedUserType = 'Admin'; // Default user type

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _confirmPasswordVisible = !_confirmPasswordVisible;
    });
  }

  Future<void> _register(BuildContext context) async {
    if (_validateFields()) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Store additional user data in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': emailController.text.trim(),
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'userType':
              selectedUserType.toLowerCase(), // Store lowercase user type
        });

        // Redirect the user based on userType
        switch (selectedUserType) {
          case 'Admin':
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AdminDashboardPage()));
            break;
          case 'Shop':
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ShopDashboardPage()));
            break;
          default:
            // Handle unsupported user type
            print('Unsupported user type');
            break;
        }
      } on FirebaseAuthException catch (e) {
        // Handle FirebaseAuthException
      } catch (e) {
        // Handle other exceptions
      }
    }
  }

  bool _validateFields() {
    bool isValid = true;

    if (firstNameController.text.trim().isEmpty) {
      isValid = false;
      // Handle empty first name error
    }

    if (lastNameController.text.trim().isEmpty) {
      isValid = false;
      // Handle empty last name error
    }

    if (emailController.text.trim().isEmpty) {
      isValid = false;
      // Handle empty email error
    }

    if (passwordController.text.trim().isEmpty) {
      isValid = false;
      // Handle empty password error
    }

    if (confirmPasswordController.text.trim().isEmpty) {
      isValid = false;
      // Handle empty confirm password error
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      isValid = false;
      // Handle password mismatch error
    }

    return isValid;
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              obscureText: !_passwordVisible,
            ),
            TextFormField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _confirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: _toggleConfirmPasswordVisibility,
                ),
              ),
              obscureText: !_confirmPasswordVisible,
            ),
            DropdownButtonFormField<String>(
              value: selectedUserType,
              items: userTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedUserType = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Register as',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _register(context),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
