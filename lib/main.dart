import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://abjnclqznfxeccdjmwkg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiam5jbHF6bmZ4ZWNjZGptd2tnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ2MTEyNTIsImV4cCI6MjA2MDE4NzI1Mn0.8vAOC7Vb_-WLMd1dnqR9aWpAzCiZRI_zaVv-yWzr5Jc',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _userId ?? 'Not signed in',
            style: TextStyle(fontSize: 24),
          ),
          ElevatedButton(
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
                  print('Sign-in aborted by user.');
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
              } catch (e) {
                print('Error during Google Sign-In: $e');
              }
            },
            child: Text("Sign in with Google"),
          ),
          if (_userId != null) // Show logout button only if the user is logged in
            ElevatedButton(
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
            ),
        ],
      ),
    ),
  );
}
}