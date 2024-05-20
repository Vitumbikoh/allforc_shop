import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({required Key key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          // User Profile Section
          const ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/profile_image.jpg'), // Replace with user's profile image
            ),
            title: Text('John Doe'), // Replace with user's name
            subtitle: Text('john.doe@example.com'), // Replace with user's email
          ),

          // Search Doctors Area
          const Padding(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search doctors',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          // Categories
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Categories', style: TextStyle(fontSize: 24)),
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: List.generate(6, (index) {
              return Center(
                child: Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      print('Category tapped.');
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      child: Center(child: Text('Category ${index + 1}')),
                    ),
                  ),
                ),
              );
            }),
          ),

          // Top Doctors Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Top Doctors', style: TextStyle(fontSize: 20)),
                TextButton(
                  onPressed: () {
                    print('See more tapped.');
                  },
                  child: const Text('See more'),
                ),
              ],
            ),
          ),
          // Vertical List of Doctors
          const Column(
            children: [
              DoctorItem(
                name: 'Dr. John Smith',
                profession: 'Cardiologist',
                rating: 4.5,
              ),
              DoctorItem(
                name: 'Dr. Emily Johnson',
                profession: 'Pediatrician',
                rating: 4.9,
              ),
              DoctorItem(
                name: 'Dr. Michael Williams',
                profession: 'Dermatologist',
                rating: 4.7,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DoctorItem extends StatelessWidget {
  final String name;
  final String profession;
  final double rating;

  const DoctorItem({
    required this.name,
    required this.profession,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/doctor_image.jpg'),
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(profession),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow),
                const Icon(Icons.star, color: Colors.yellow),
                const Icon(Icons.star, color: Colors.yellow),
                const Icon(Icons.star, color: Colors.yellow),
                const Icon(Icons.star_border, color: Colors.yellow),
                Text('($rating ⭐)', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
