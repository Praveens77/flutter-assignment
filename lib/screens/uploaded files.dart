import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task/utils.dart';

class UploadedFilesPage extends StatefulWidget {
  const UploadedFilesPage({Key? key}) : super(key: key);

  @override
  _UploadedFilesPageState createState() => _UploadedFilesPageState();
}

class _UploadedFilesPageState extends State<UploadedFilesPage> {
  late Future<List<DocumentSnapshot>> _userFiles;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    _currentUser = FirebaseAuth.instance.currentUser!;
    setState(() {
      _userFiles = _fetchUserFiles();
    });
  }

  Future<List<DocumentSnapshot>> _fetchUserFiles() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('data')
        .where('userId', isEqualTo: _currentUser.uid)
        .get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customText("Your Uploaded Files", 18.0, black, FontWeight.bold),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: _userFiles,
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No uploaded files found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var data = snapshot.data![index].data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: lightBlack),
                      borderRadius: BorderRadius.circular(7)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow('Category', data['category']),
                        const Divider(),
                        _buildRow('SubCategory', data['subcategory']),
                        const Divider(),
                        _buildRow('Comments', _formatDescription(data['description'])),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Text('$title:'),
          const SizedBox(width: 8.0),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDescription(String description) {
    if (description.length > 40) {
      return '${description.substring(0, 40)}...';
    } else {
      return description;
    }
  }
}
