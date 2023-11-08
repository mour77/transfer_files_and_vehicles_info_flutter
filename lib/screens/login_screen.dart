import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:transfer_files_and_vehicles_info_flutter/screens/home_page.dart';








class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isSigningIn = false;



  @override
  void initState() {
    super.initState();
    isSignedIn();

  }




  void isSignedIn(){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        navigateToHomeScreen();
      }
    });

  }



  Future<void> _signInWithGoogle() async {
    setState(() {
      _isSigningIn = true;
    });

    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        setState(() {
          _isSigningIn = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        // Navigate to the next screen or perform the necessary action on successful login
        print('mpikeeeeeeee');
        navigateToHomeScreen();

      } else {
        // Handle the login failure
        print('dennnnnnnnnnn    mpikeeeeeeee');

      }
    } catch (error) {
      print('Google Sign-In Error: $error');
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return


      Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const FlutterLogo(
                  size: 100.0,
               // colors: Colors.blue,
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Welcome to My App",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                const TextField(
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20.0),
                const TextField(
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle login button press
                  },
                  child: const Text("Login"),
                ),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    // Handle forgot password
                  },
                  child: const Text("Forgot Password?"),
                ),
                const SizedBox(height: 10.0),
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    // Handle registration
                  },
                  child: const Text("Sign Up"),
                ),


                const SizedBox(height: 20.0),
                Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Colors.blue, // <-- Button color
                        foregroundColor: Colors.red, // <-- Splash color
                      ),
                      child:  const Icon(Icons.facebook_outlined, color: Colors.white),
                    ),


                    const SizedBox(width: 20.0),

                    ElevatedButton(

                      onPressed: _isSigningIn ? null : _signInWithGoogle,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Colors.red, // <-- Button color
                        foregroundColor: Colors.white, // <-- Splash color
                      ),
                      child:  _isSigningIn
                                ? CircularProgressIndicator()
                                : const Icon(Icons.g_translate_outlined, color: Colors.white),
                          ),

                  ],
                ),


              ],
            ),
          ),
        ),
      );




  }





  void navigateToHomeScreen(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}






