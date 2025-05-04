import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String adduLogo;

  const Header({
    super.key,
    required this.adduLogo,
  });

  Future<void> _logOut() async {
    try {
      await Supabase.instance.client.auth.signOut();

      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      Get.offAllNamed('/login');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 80, // Custom height for the AppBar
      title: Container(
        margin: const EdgeInsets.only(top: 0),
        child: Row(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Image.network(adduLogo, fit: BoxFit.contain),
            ),
            const SizedBox(width: 10),
            Text(
              'Ateneo Events',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _logOut, // Call the logout function
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80); // Set the height of the AppBar
}