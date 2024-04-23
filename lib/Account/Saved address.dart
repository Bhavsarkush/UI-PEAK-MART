import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Saveaddress extends StatefulWidget {
  const Saveaddress({Key? key});

  @override
  State<Saveaddress> createState() => _SaveaddressState();
}

class _SaveaddressState extends State<Saveaddress> {
  late Stream<QuerySnapshot> _addressesStream;

  @override
  void initState() {
    super.initState();
    _addressesStream = FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('Address')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.cyan,
        title: Text(
          'Saved Addresses',
          style: TextStyle(color: CupertinoColors.black,fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _addressesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final addresses = snapshot.data!.docs;
            return ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final doc = addresses[index];
                final addressData = doc.data() as Map<String, dynamic>;
                return AddressItem(
                  name: addressData['name'],
                  address: addressData['address'],
                  onEditPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditAddressScreen(
                          addressDocumentId: doc.id,
                          name: addressData['name'],
                          address: addressData['address'],
                        ),
                      ),
                    );
                  },
                  onDeletePressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Address'),
                        content: Text(
                          'Are you sure you want to delete this address?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('User')
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .collection('Address')
                                  .doc(doc.id)
                                  .delete();
                              Navigator.pop(context); // Close dialog
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Text('No data available.');
          }
        },
      ),

    );
  }
}


class AddressItem extends StatelessWidget {
  final String name;
  final String address;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const AddressItem({
    Key? key,
    required this.name,
    required this.address,
    required this.onEditPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(address),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: onEditPressed,
                color: Colors.blue,
              ),
              SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: onDeletePressed,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Add New Address',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('User')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .collection('Address')
                    .add({
                  'name': _nameController.text,
                  'address': _addressController.text,
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text('Add Address'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditAddressScreen extends StatefulWidget {
  final String addressDocumentId;
  final String name;
  final String address;

  const EditAddressScreen({
    Key? key,
    required this.addressDocumentId,
    required this.name,
    required this.address,
  }) : super(key: key);

  @override
  _EditAddressScreenState createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _addressController = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        centerTitle: true,
        title: Text(
          'Edit Address',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView to avoid overflow when keyboard appears
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                // Use OutlineInputBorder for a consistent look
                labelStyle: TextStyle(
                    fontSize: 18), // Bigger font size for labels
              ),
              style: TextStyle(fontSize: 18), // Match text size with label
            ),
            SizedBox(height: 16), // Consistent spacing
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                labelStyle: TextStyle(fontSize: 18),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30), // More space before the button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('User')
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .collection('Address')
                        .doc(widget.addressDocumentId)
                        .update({
                      'name': _nameController.text,
                      'address': _addressController.text,
                    });
                    Navigator.pop(context);
                  } catch (e) {
                    print('Error updating address: $e');
                    // Ideally, show an error message to the user
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  // Text color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  // Larger touch area
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
