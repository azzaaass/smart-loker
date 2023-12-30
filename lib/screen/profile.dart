import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tubes_iot/style/color.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final ref = FirebaseDatabase.instance.ref();
  final GlobalKey<ImageProfileState> childKey = GlobalKey<ImageProfileState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    ImageProfile(
                      key: childKey,
                      path: "profile_images/$uid",
                    ),
                    ChangeProfile(
                      childKey: childKey,
                    ),
                  ],
                ),
                StreamBuilder(
                  stream: ref.onValue,
                  builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (snapshot.connectionState == ConnectionState) {
                      return const Text("waiting...");
                    } else if (snapshot.hasData) {
                      final username = snapshot.data!.snapshot
                          .child("usersData/$uid/username")
                          .value;
                      final phoneNumber = snapshot.data!.snapshot
                          .child("usersData/$uid/phoneNumber")
                          .value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(username.toString()),
                          Text(phoneNumber.toString()),
                        ],
                      );
                    }
                    return const Text(" ");
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImageProfile extends StatefulWidget {
  final String path;
  const ImageProfile({super.key, required this.path});

  @override
  State<ImageProfile> createState() => ImageProfileState();
}

class ImageProfileState extends State<ImageProfile> {
  late Future<String> imageUrl;
  Future<String> getImageUrl(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      return await ref.getDownloadURL();
    } catch (error) {
      return "https://firebasestorage.googleapis.com/v0/b/tubes-iot-affe1.appspot.com/o/profile_images%2Fno-photo-available.png?alt=media&token=99c3e85d-64ff-4353-82a3-cb746f81e2c1";
    }
  }

  @override
  void initState() {
    imageUrl = getImageUrl(widget.path);
    super.initState();
  }

  void changeState() {
    setState(() {
      imageUrl = getImageUrl(widget.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: imageUrl,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            radius: 40.0,
            backgroundColor: brown,
            child: const CircularProgressIndicator(color: Colors.white),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return CircleAvatar(
            radius: 40.0,
            backgroundImage: NetworkImage(snapshot.data!),
            backgroundColor: brown,
          );
        } else {
          return const Center(child: Text('No image available'));
        }
      },
    );
  }
}

class ChangeProfile extends StatefulWidget {
  final GlobalKey<ImageProfileState> childKey;
  const ChangeProfile({super.key, required this.childKey});

  @override
  State<ChangeProfile> createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  File? _image;
  final picker = ImagePicker();
  User? user = FirebaseAuth.instance.currentUser;
  String imageUrl = '';
  final storage = FirebaseStorage.instance;

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
    String uid = user?.uid ?? '';
    if (_image != null) {
      Reference ref =
          FirebaseStorage.instance.ref().child('profile_images/$uid');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
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
    return IconButton(
      onPressed: () async {
        await getImage();
        await uploadImageToFirebase();
        widget.childKey.currentState?.changeState();
      },
      icon: Icon(Icons.change_circle),
    );
  }
}

// ------------------------------------------------------------------------------- realtime storage

// import 'dart:async';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// class FirebaseImageUpdater extends StatefulWidget {
//   @override
//   _FirebaseImageUpdaterState createState() => _FirebaseImageUpdaterState();
// }

// class _FirebaseImageUpdaterState extends State<FirebaseImageUpdater> {
//   late String _imageUrl = ''; // Atur nilai default

//   @override
//   void initState() {
//     super.initState();
//     updateImageUrlPeriodically(Duration(seconds: 2)); // Memeriksa setiap 10 detik
//   }

//   void updateImageUrlPeriodically(Duration interval) {
//     Timer.periodic(interval, (timer) async {
//       try {
//         FirebaseStorage storage = FirebaseStorage.instance;
//         final ref = storage.ref().child('testing/KTM GIGIH.jpg');
//         String newImageUrl = await ref.getDownloadURL();

//         if (newImageUrl != _imageUrl) {
//           setState(() {
//             _imageUrl = newImageUrl;
//           });
//         }
//       } catch (error) {
//         print('Error fetching image URL: $error');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebase Image Updater'),
//       ),
//       body: Center(
//         child: _imageUrl.isNotEmpty
//             ? Image.network(
//                 _imageUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Text('Error loading image: $error');
//                 },
//               )
//             : Text('No image available'),
//       ),
//     );
//   }
// }


// ---------------------------------------------------------------------- get image berhasil

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// class ProfileImageUpload extends StatefulWidget {
//   @override
//   State<ProfileImageUpload> createState() => _ProfileImageUploadState();
// }

// class _ProfileImageUploadState extends State<ProfileImageUpload> {
//   Future<String> getImageUrl(String imagePath) async {
//     final ref = FirebaseStorage.instance.ref().child(imagePath);
//     return await ref.getDownloadURL();
//   }

//   late Future<String> imageUrl;

//   @override
//   void initState() {
//     super.initState();
//     imageUrl = getImageUrl('testing/KTM GIGIH.jpg');
//   }

//   @override
//   Widget build(BuildContext context) {
//    return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebase Image Example'),
//       ),
//       body: FutureBuilder<String>(
//         future: imageUrl,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             return Center(
//               child: Image.network(
//                 snapshot.data!,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Text('Error loading image: $error');
//                 },
//               ),
//             );
//           } else {
//             return Center(child: Text('No image available'));
//           }
//         },
//       ),
//     );
//   }
// }


// --------------------------------------------------------------------------------- upload image berhasil

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:io';

// import 'package:tubes_iot/screen/login_screen.dart';

// class ProfileImageUpload extends StatefulWidget {
//   const ProfileImageUpload({super.key});

//   @override
//   _ProfileImageUploadState createState() => _ProfileImageUploadState();
// }

// class _ProfileImageUploadState extends State<ProfileImageUpload> {
//   File? _image;
//   final picker = ImagePicker();
//   User? user = FirebaseAuth.instance.currentUser;
//   String imageUrl = '';
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final storage = FirebaseStorage.instance;

//   // void signOut() async {
//   //   await _auth.signOut();
//   //   print('Berhasil keluar dari sesi');
//   // }


//   Future<String> getImageURL(String imagePath) async {
//     final ref = storage.ref().child(imagePath);
//     imageUrl = await ref.getDownloadURL();
//     return await ref.getDownloadURL();
//   }

//   Future getImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future uploadImageToFirebase() async {
//     String uid = user?.uid ?? '';
//     if (_image != null) {
//       Reference ref =
//           FirebaseStorage.instance.ref().child('profile_images/$uid');
//       UploadTask uploadTask = ref.putFile(_image!);
//       TaskSnapshot storageTaskSnapshot =
//           await uploadTask.whenComplete(() => null);
//       String imageURL = await storageTaskSnapshot.ref.getDownloadURL();

//       // Simpan imageURL ke database Firebase di sini
//       // Misalnya, Firestore atau Realtime Database
//       print('Image URL: $imageURL');
//     } else {
//       print('No image selected.');
//     }
//   }

//   @override
//   void initState() async {
//     // TODO: implement initState
//     imageUrl =  await storage.ref().child("profile_images/images1.png").getDownloadURL();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String uid = user?.uid ?? '';
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Image.network(imageUrl),
//             TextButton(
//                 onPressed: () {
//                   setState(() {
                    // signOut();
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => LoginScreen(),
                    //     ));
                
//                   });
//                 },
//                 child: Text("Keluar")),

//             // _image != null
//             //     ? Image.file(
//             //         _image!,
//             //         height: 200,
//             //         width: 200,
//             //       )
//             //     : const Text('No image selected.'),
//             // const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 getImage();
//                 uploadImageToFirebase();
//               },
//               child: const Text('Select Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
