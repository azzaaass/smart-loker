import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tubes_iot/style/color.dart';

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