import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'createIDCardPage.dart'; 
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

const Color kDarkGreen = Color(0xFF0F3B33);
const Color kBlueDot = Color(0xFF1EA7E1);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ID Card',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFE6EFEA),
        appBar: AppBar(
        title: const Text('ID Card'),
        backgroundColor: Colors.grey,
        ),
        body: const SafeArea(
          child: Center(
            child: IDCard(),
          ),
        ),
        drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
        child: Text(
          'Menu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),

      Builder(
        builder: (context) {
          return ListTile(
            leading: const Icon(Icons.card_membership),
            title: const Text('Create your ID card'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to create page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateIDCardPage(),
                ),
              );
            },
          );
        }
      ),
    ],
  ),
),
      ),
    );
  }
}

class IDCard extends StatelessWidget {
  final File? photoFile;
  final String? studentID;
  final String? studentName;
  final String? program;
  final String? department;
  final String? country;

  const IDCard({
    super.key,
    this.photoFile,
    this.studentID,
    this.studentName,
    this.program,
    this.department,
    this.country,
  });

  static const String photo = 'assets/images/profile.JPG';
  static const String logo = 'assets/images/IUT_logo.png';

  static const double aspect = 996 / 1544;

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 400;

    return SizedBox(
      width: cardWidth,
      child: AspectRatio(
        aspectRatio: aspect,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
             
              Container(color: kDarkGreen),

              Positioned.fill(
                child: Column(
                  children: [
                  
                    const SizedBox(height: 245),
                
                    Expanded(
                      child: Container(color: Colors.white),
                    ),
                  
                    const SizedBox(height: 30),
                  ],
                ),
              ),

              // Card contents
              Column(
                children: [
                  // Top green header area
                  Container(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 3, left: 12, right: 12),
                    child: Column(
                      children: [
                      
                        SizedBox(
                          height: 100,
                          child: Center(
                            child: Image.asset(
                              logo,
                              height: 85,
                            ),
                          ),
                        ),

                        const SizedBox(height: 7),

                     
                        Text(
                          'ISLAMIC UNIVERSITY OF TECHNOLOGY',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.bebasNeue(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.0,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),

                        
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: kDarkGreen, width: 6),
                            ),
                            child: ClipRRect(
                              child: photoFile != null
                                  ? Image.file(
                                      photoFile!,
                                      width: 130,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    )
                                : Image.asset(
                                photo,
                                width: 130,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                        
                          Padding(padding:  const EdgeInsets.only(left: 35.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.vpn_key,
                                        size: 18, color: Colors.black87),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Student ID',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                            
                                Container(
                                  width: 145,
                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    color: kDarkGreen,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kBlueDot,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        studentID ?? '210041131',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.person,
                                        size: 18, color: Colors.black87),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Student Name',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  studentName ?? 'RUMMAN ADIB',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: kDarkGreen,
                                    letterSpacing: 0.3,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Program row
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.school,
                                        size: 18, color: Colors.black87),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Program ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      program ??'B.Sc. in CSE',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: kDarkGreen,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                // Department row
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.people_rounded,
                                        size: 18, color: Colors.black87),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Department ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      department ?? 'CSE',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: kDarkGreen,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                // Location row
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.location_on_outlined,
                                        size: 18, color: Colors.black87),
                                    const SizedBox(width: 8),
                                    Text(
                                      country ?? 'Bangladesh',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: kDarkGreen,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  
                  Container(
                    
                    color: kDarkGreen,
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'A subsidiary organ of OIC',
                          style: GoogleFonts.lexend(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}