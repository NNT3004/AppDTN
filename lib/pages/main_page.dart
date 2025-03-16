import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_dtn/components/bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('main page'),
      ),
    );
  }
}