import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({this.colour,this.buttonName, @required this.onPressed});
  final Color colour;
  final String buttonName;
  final Function onPressed ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: colour,//Colors.lightBlueAccent,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonName,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}