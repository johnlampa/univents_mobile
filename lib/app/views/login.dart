import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:univents_mobile/main.dart';
import 'package:get/get.dart';
import 'package:univents_mobile/config/config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ignore: unused_field
  String? _userId;

  @override
  void initState() {
    super.initState();

    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user.id;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          background(),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
                vertical: MediaQuery.of(context).size.height * 0.25,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  logInHeader(context),
                  SizedBox(height: 10),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255,28,59,138).withOpacity(0.7),
                          Color.fromARGB(255, 69,121,190).withOpacity(0.7), 
                        ],                           
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        usernameField(),
                        SizedBox(height: 10),
                        passwordField(),
                        SizedBox(height: 20),
                        signInButton(),
                      ],
                    ),
                  ),
                  // Text(
                  //   _userId ?? 'Not signed in',
                  //   style: TextStyle(fontSize: 12, color: Colors.white),
                  // ),
                  // signInButton(),
                  // if (_userId != null) // Show logout button only if the user is logged in
                  //   signOutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Password",
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(height: 4),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Column usernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "AdDUNET Username",
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(height: 4),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Row logInHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 70,
          width: 70,
          child: Image.network(
            adduLogo,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ateneo",
              style: TextStyle(
                fontSize: 40,
                height: 0.9,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Events",
              style: TextStyle(
                fontSize: 40,
                height: 0.9,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container background() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            logInBGImage,
          ),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.5), // Adjust the color and opacity
            BlendMode.darken, // Blend mode for the color filter
          ),
        ),
      ),
    );
  }

  ElevatedButton signInButton() {
    return ElevatedButton(
      onPressed: () async {
        try {
          const webClientId = '371734532339-4mv4nja0baj7539q8o26gdvhmagotunr.apps.googleusercontent.com';
          const iosClientId = '371734532339-av5a053e4sf1ik15t48kl608qko464qa.apps.googleusercontent.com';

          final GoogleSignIn googleSignIn = GoogleSignIn(
            clientId: iosClientId,
            serverClientId: webClientId,
          );
          final googleUser = await googleSignIn.signIn();
          if (googleUser == null) {
            _showAlertDialog(
              context,
              'Sign-In Cancelled',
              'You have cancelled the sign-in process.',
            );
            return;
          }

          final email = googleUser.email;
          // print('Signed-in email: $email');
          const allowedDomain = 'addu.edu.ph';
          if (!email.endsWith('@$allowedDomain')) {
            _showAlertDialog(
              context,
              'Access Denied',
              'You must use a $allowedDomain email to sign in.',
            );
            //print('Access Denied: Invalid email domain');
            return;
          }

          final googleAuth = await googleUser.authentication;
          final accessToken = googleAuth.accessToken;
          final idToken = googleAuth.idToken;

          if (accessToken == null || idToken == null) {
            throw 'Missing tokens';
          }

          await supabase.auth.signInWithIdToken(
            provider: OAuthProvider.google,
            idToken: idToken,
            accessToken: accessToken,
          );

          // Check if the email exists in the accounts table
          final currentUser = supabase.auth.currentUser;
          final userEmail = currentUser?.userMetadata?['email'];
          final fullName = currentUser?.userMetadata?['full_name'];

          if (userEmail == null || fullName == null) {
            throw 'User email or full name is missing in metadata';
          }

          // Split full_name into first name and last name
          final nameParts = fullName.split(' ');
          final firstName = nameParts.sublist(0, nameParts.length - 1).join(' ');
          final lastName = nameParts.last;

          // Query the accounts table to check if the email exists
        final response = await supabase
          .from('accounts')
          .select('email')
          .eq('email', userEmail);

        if (response == null) {
          throw 'Error: No response from Supabase';
        }

        final accounts = response as List;

        if (accounts.isEmpty) {
          // Email does not exist, insert a new row
          final insertResponse = await supabase
              .from('accounts')
              .insert({
                'firstname': firstName,
                'lastname': lastName,
                'email': userEmail,
                'role': 'student',
                'status': true, // Boolean true
              });

          print('New account created: $insertResponse');
        } else {
          print('Email already exists in accounts table');
        }

          Get.offNamed('/dashboard');
        } catch (e) {
          _showAlertDialog(
            context,
            'Access Denied',
            'You must use an AdDU email to sign in.',
          );
          print('Error during Google Sign-In: $e');
        }
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Log in with",
              style: TextStyle(
                fontWeight: FontWeight.w900, 
                color: Colors.black, 
              ),
            ),
            SizedBox(width: 2),
            SizedBox(
              width: 30, 
              height: 30,
              child: Image.network(
                googleLogo,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  ElevatedButton signOutButton() {
    return ElevatedButton(
      onPressed: () async {
      try {
        // Sign out from Supabase
        await supabase.auth.signOut();

        // Sign out from GoogleSignIn
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();

        // Clear the user ID
        setState(() {
          _userId = null;
        });
      } catch (e) {
        print('Error during logout: $e');
      }
    },
      child: Text("Logout"),
    );
  }
}