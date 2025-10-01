import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart';

const Color kDarkGreen = Color(0xFF0F3B33);

class CreateIDCardPage extends StatefulWidget {
  const CreateIDCardPage({super.key});

  @override
  State<CreateIDCardPage> createState() => _CreateIDCardPageState();
}

class _CreateIDCardPageState extends State<CreateIDCardPage> {
  File? _image;
  final picker = ImagePicker();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _programController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your ID Card'),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _image != null
                  ? CircleAvatar(
                      radius: 60,
                      backgroundImage: FileImage(_image!),
                    )
                  : CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.add_a_photo, size: 40),
                    ),
            ),
            const SizedBox(height: 16),
            _buildTextField(_idController, 'Student ID'),
            const SizedBox(height: 10),
            _buildTextField(_nameController, 'Student Name'),
            const SizedBox(height: 10),
            _buildTextField(_programController, 'Program'),
            const SizedBox(height: 10),
            _buildTextField(_departmentController, 'Department'),
            const SizedBox(height: 10),
            _buildTextField(_countryController, 'Country'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[100],
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Scaffold(
                      backgroundColor: const Color(0xFFE6EFEA),
                      appBar: AppBar(
                        title: const Text('Your ID Card'),
                        backgroundColor: Colors.grey,
                      ),
                      body: Center(
                        child: IDCard(
                          photoFile: _image,
                          studentID: _idController.text,
                          studentName: _nameController.text,
                          program: _programController.text,
                          department: _departmentController.text,
                          country: _countryController.text,
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Generate', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
