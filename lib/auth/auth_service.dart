import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Future<String?> register({
    required String username,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user?.uid ?? '';
      print(uid);

      databaseReference.child('usersData/$uid').set({
        'username' : username,
        'phoneNumber' : phoneNumber,
      }).then((_) {
        print('Data berhasil ditambahkan.');
      }).catchError((error) {
        print('Error: $error');
      });

      return 'Registration Success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Login Success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
