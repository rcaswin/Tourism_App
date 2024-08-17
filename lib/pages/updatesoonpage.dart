import 'package:flutter/material.dart';

class UpdateSoonPage extends StatefulWidget {
  @override
  _UpdateSoonPageState createState() => _UpdateSoonPageState();
}

class _UpdateSoonPageState extends State<UpdateSoonPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  'content will be update soon...',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
