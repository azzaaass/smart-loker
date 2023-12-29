// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class FirebaseImageWidget extends StatefulWidget {
//   final String imagePath;

//   FirebaseImageWidget({required this.imagePath});

//   @override
//   _FirebaseImageWidgetState createState() => _FirebaseImageWidgetState();
// }

// class _FirebaseImageWidgetState extends State<FirebaseImageWidget> {
//   late Future<String> _imageURLFuture;

//   Future<String> getFirebaseImageURL(String imagePath) async {
//     final Reference ref = FirebaseStorage.instance.ref().child(imagePath);
//     final String imageURL = await ref.getDownloadURL();
//     return imageURL;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _imageURLFuture = getFirebaseImageURL(widget.imagePath);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebase Image'),
//       ),
//       body: Center(
//         child: FutureBuilder<String>(
//           future: _imageURLFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else if (!snapshot.hasData || snapshot.data == null) {
//               return Text('No Image Found');
//             } else {
//               return Image.network(
//                 snapshot.data!,
//                 fit: BoxFit.cover, // Atur sesuai kebutuhan
//                 width: 200, // Atur sesuai kebutuhan
//                 height: 200, // Atur sesuai kebutuhan
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfileImageUpload extends StatefulWidget {
  const ProfileImageUpload({super.key});

  @override
  _ProfileImageUploadState createState() => _ProfileImageUploadState();
}

class _ProfileImageUploadState extends State<ProfileImageUpload> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImageToFirebase() async {
    if (_image != null) {
      Reference ref = FirebaseStorage.instance.ref().child('profile_images/image1.jpg');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() => null);
      String imageURL = await storageTaskSnapshot.ref.getDownloadURL();

      // Simpan imageURL ke database Firebase di sini
      // Misalnya, Firestore atau Realtime Database
      print('Image URL: $imageURL');
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Image.file(
                    _image!,
                    height: 200,
                    width: 200,
                  )
                : const Text('No image selected.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadImageToFirebase,
              child: const Text('Upload Image to Firebase'),
            ),
          ],
        ),
      ),
    );
  }
}
