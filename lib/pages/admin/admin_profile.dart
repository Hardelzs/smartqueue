// For the API ENDPOINT for admin 


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class AdminProfilePage extends StatefulWidget {
//   const AdminProfilePage({super.key});

//   @override
//   State<AdminProfilePage> createState() => _AdminProfilePageState();
// }

// class _AdminProfilePageState extends State<AdminProfilePage> {
//   Map<String, dynamic>? _profileData;
//   bool _isLoading = true;
//   String? _errorMessage;

//   static const String apiBase = 'https://queueless-7el4.onrender.com';

//   @override
//   void initState() {
//     super.initState();
//     _fetchProfile();
//   }

//   Future<void> _fetchProfile() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final authToken = prefs.getString('auth_token');

//       if (authToken == null) {
//         setState(() {
//           _errorMessage = 'No authentication token found. Please login first.';
//           _isLoading = false;
//         });
//         return;
//       }

//       final response = await http.get(
//         Uri.parse('$apiBase/api/v1/admin/profile'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $authToken',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           _profileData =
//               data['data'] ?? data; // Adjust based on API response structure
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _errorMessage = 'Failed to load profile: ${response.statusCode}';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F7F7),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           'Admin Profile',
//           style: GoogleFonts.poppins(
//             color: Colors.black,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : _errorMessage != null
//             ? Center(
//                 child: Text(
//                   _errorMessage!,
//                   style: GoogleFonts.poppins(color: Colors.red),
//                 ),
//               )
//             : Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 20),
//                     CircleAvatar(
//                       radius: 60,
//                       backgroundColor: Colors.deepPurpleAccent,
//                       child: Icon(Icons.person, size: 60, color: Colors.white),
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       _profileData?['name'] ?? 'Unknown Name',
//                       style: GoogleFonts.poppins(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       _profileData?['email'] ?? 'No email provided',
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     Card(
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: Column(
//                           children: [
//                             _buildProfileItem(
//                               icon: Icons.business,
//                               label: 'Organization',
//                               value: _profileData?['organization'] ?? 'N/A',
//                             ),
//                             const Divider(),
//                             _buildProfileItem(
//                               icon: Icons.phone,
//                               label: 'Phone',
//                               value: _profileData?['phone'] ?? 'N/A',
//                             ),
//                             const Divider(),
//                             _buildProfileItem(
//                               icon: Icons.location_on,
//                               label: 'Location',
//                               value: _profileData?['location'] ?? 'N/A',
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildProfileItem({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.deepPurpleAccent),
//         const SizedBox(width: 15),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
//             ),
//             Text(
//               value,
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  String? _name;
  String? _email;
  String? _organization;
  String? _phone;
  String? _location;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _name = prefs.getString('user_name') ?? 'Admin User';
        _email = prefs.getString('user_email') ?? 'admin@example.com';
        _organization = prefs.getString('organization') ?? 'Your Organization';
        _phone = prefs.getString('phone') ?? '+1 234 567 890';
        _location = prefs.getString('location') ?? 'City, Country';
      });
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Admin Profile',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.deepPurpleAccent,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                _name ?? 'Loading...',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _email ?? 'Loading...',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildProfileItem(
                        icon: Icons.business,
                        label: 'Organization',
                        value: _organization ?? 'N/A',
                      ),
                      const Divider(),
                      _buildProfileItem(
                        icon: Icons.phone,
                        label: 'Phone',
                        value: _phone ?? 'N/A',
                      ),
                      const Divider(),
                      _buildProfileItem(
                        icon: Icons.location_on,
                        label: 'Location',
                        value: _location ?? 'N/A',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurpleAccent),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}