import 'package:flutter/material.dart';

circularProgress() {
  //return Text("circular progress");
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 22.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lightGreenAccent),
    ),
  );
}

linearProgress() {
  // return Text("linear progress");
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 22.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lightGreenAccent),
    ),
  );
}
