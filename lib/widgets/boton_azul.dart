import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {

  final String texto;
  final Function onPressed;

  BotonAzul({
    @required this.texto,
    @required this.onPressed, 
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue,
      shape: StadiumBorder(),
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: 50,
        child: Center(
          child: Text(this.texto, style: TextStyle(color: Colors.white, fontSize: 16),),
        ),
      ),
    );
  }
}