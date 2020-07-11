import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/chats_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/splash_screen.dart';
import 'package:flash_chat/screens/sync_contacts.dart';
import 'package:flash_chat/screens/terms_and_conditions.dart';
import 'package:flash_chat/screens/verify_number.dart';
import 'package:flutter/material.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SplashScreen.id,
      // initialRoute: WelcomeScreen.id,
      // initialRoute: VerifyNumberScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        TermsAndConditions.id: (context) => TermsAndConditions(),
        LoginScreen.id: (context) => LoginScreen(),
        VerifyNumberScreen.id: (context) => VerifyNumberScreen('blahdsjadasjk'),
        SyncContacts.id: (context) => SyncContacts(),
        // ProfileScreen.id: (context) => ProfileScreen(),
        ChatsScreen.id: (context) => ChatsScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
