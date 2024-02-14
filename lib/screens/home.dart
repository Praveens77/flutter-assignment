import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_task/screens/uploaded%20files.dart';
import 'package:flutter_task/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedCategory;
  String? _selectedSubcategory;
  String? _description;
  File? _selectedFile;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> categories = ['Identity', 'Residence', 'Finance'];
  final Map<String, List<String>> subcategories = {
    'Identity': ['Passport', 'PAN Card', 'Visa'],
    'Residence': ['Water bill', 'Electricity bill', 'Gas bill'],
    'Finance': ['Salary', 'Income', 'Expenditures'],
  };

  void _saveToFirestore(String fileUrl, String userId) async {
    try {
      await _firestore.collection('data').add({
        'userId': userId,
        'category': _selectedCategory,
        'subcategory': _selectedSubcategory,
        'description': _description,
        'fileUrl': fileUrl,
      });
      Fluttertoast.showToast(msg: 'File uploaded and data saved successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  Future<void> _uploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      } else {
        Fluttertoast.showToast(msg: 'No file selected');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  Future<void> _handleUpload() async {
    try {
      String userId = _auth.currentUser!.uid;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('uploads/$userId');
      firebase_storage.UploadTask uploadTask = ref.putFile(_selectedFile!);
      firebase_storage.TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      _saveToFirestore(downloadUrl, userId);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customText("Upload Documents", 18.0, black, FontWeight.bold),
        actions: [
          InkWell(
            onTap: () {
              // ignore: use_build_context_synchronously
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UploadedFilesPage()));
            },
            child:
                customText("View Uploads", 16.0, lightBlack, FontWeight.bold),
          ),
          const SizedBox(width: 18)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // category
              DropdownButtonFormField(
                value: _selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value as String?;
                    _selectedSubcategory = null;
                  });
                },
                hint: const Text('Select Category'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // sub category
              DropdownButtonFormField(
                value: _selectedSubcategory,
                items: _selectedCategory != null
                    ? subcategories[_selectedCategory!]!.map((subcategory) {
                        return DropdownMenuItem(
                          value: subcategory,
                          child: Text(subcategory),
                        );
                      }).toList()
                    : [],
                onChanged: (value) {
                  setState(() {
                    _selectedSubcategory = value as String?;
                  });
                },
                hint: const Text('Select SubCategory'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // description
              TextField(
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // upload file
              InkWell(
                onTap: () {
                  _uploadFile();
                },
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, size: 50),
                      SizedBox(height: 10),
                      Text("Browse to upload files", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // upload button
              MaterialButton(
                elevation: 0,
                color: _selectedFile != null ? black : Colors.black38,
                onPressed: _selectedFile != null ? _handleUpload : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                  child: customText("Upload", 18.0, white, FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20), 
            ],
          ),
        ),
      ),
    );
  }
}
