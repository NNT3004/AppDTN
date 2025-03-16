import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_dtn/components/bottom_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('Profile page'),
      ),
    );
  }
}