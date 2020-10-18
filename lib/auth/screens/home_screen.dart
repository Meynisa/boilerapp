import 'package:flutter/material.dart';
import 'package:project_boilerplate/utils/widgets/widget_models.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, 'Home', 0),
      body: Container(
        color: Colors.amber,
      ),
    );
  }
}
