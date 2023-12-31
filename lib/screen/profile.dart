import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_iot/data/data.dart';
import 'package:tubes_iot/screen/component/change_profile.dart';
import 'package:tubes_iot/screen/component/image_profile.dart';
import 'package:tubes_iot/screen/login_screen.dart';
import 'package:tubes_iot/style/color.dart';
import 'package:tubes_iot/style/text.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final email = FirebaseAuth.instance.currentUser?.email;
  final ref = FirebaseDatabase.instance.ref();
  final GlobalKey<ImageProfileState> childKey = GlobalKey<ImageProfileState>();
  bool isDark = false;

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: smoothGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    color: whiteBone, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.antiAlias,
                      children: [
                        ImageProfile(
                          key: childKey,
                          path: "profile_images/$uid",
                        ),
                        Positioned(
                          right: -12,
                          bottom: -12,
                          child: ChangeProfile(
                            childKey: childKey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    StreamBuilder(
                      stream: ref.onValue,
                      builder:
                          (context, AsyncSnapshot<DatabaseEvent> snapshot) {
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
                              Text(
                                truncateText(username.toString(), 20),
                                style: text_14_700,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                truncateText(email.toString(), 20),
                                style: text_12_500,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                softWrap: false,
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                phoneNumber.toString(),
                                style: text_12_500,
                              ),
                            ],
                          );
                        }
                        return const Text(" ");
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                flex: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: whiteBone,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListView.builder(
                    itemCount: setting.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () {
                            final auth = FirebaseAuth.instance;
                            if (index != 3 && index != 6) {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => setting[index].widget,
                                ),
                              );
                            } else if (index == 6) {
                              auth.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            }
                          },
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          minLeadingWidth: 25,
                          leading: FaIcon(
                            setting[index].icon,
                            size: 20,
                            color: textH2,
                          ),
                          title: Text(
                            setting[index].title,
                            style: text_14_500,
                          ),
                          trailing: setting[index].title == "Dark mode"
                              ? SizedBox(
                                  width: 40,
                                  height: 20,
                                  child: Switch(
                                    value: isDark,
                                    activeColor: orange,
                                    onChanged: (value) {
                                      setState(() {
                                        isDark = !isDark;
                                      });
                                    },
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                )
                              : null);
                    },
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      "Tubes Pemmob © 2023",
                      style: text_10_300,
                    ),
                  ))
            ],
          ),
        ),
      ),
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
