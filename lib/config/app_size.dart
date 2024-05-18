import 'package:flutter/cupertino.dart';

double screenWidth(double size,BuildContext context){
return ( MediaQuery.of(context).size.width/412)* size;
}

double screenHeight(double size,BuildContext context){
return ( MediaQuery.of(context).size.height/804)* size;
}

SizedBox h8=SizedBox(height: 8,);
SizedBox h16=SizedBox(height: 16,);
SizedBox w8=SizedBox(width: 8,);
SizedBox w16=SizedBox(width: 16,);