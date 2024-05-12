import 'package:flutter/material.dart';
import 'shop/dashboard.dart';



class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                 Navigator.push(
                   context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                // Navigate to registration page
              },
              child: Text('Create an Account'),
            ),
          ],
        ),
      ),
    );
  }
}
