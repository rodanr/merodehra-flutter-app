import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:merodehra/models/user_data.dart';
import 'package:merodehra/views/loading_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserData())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        accentColor: Colors.blueAccent,
      ),
      home: LoadingPage(),
    );
  }
}
