import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  final String text;

  LoadingPage(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        width: 200.0,
        height: 150.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 10.0,),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}