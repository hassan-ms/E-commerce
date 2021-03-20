import 'package:flutter/material.dart';
class FlexSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
          decoration: BoxDecoration(
            gradient: LinearGradient( colors: [
                  
                   Color(0xFF11249F),
                   Color(0xFF3383CD),
                ],
                 begin: Alignment.topLeft,
                 end: Alignment.bottomRight,
                stops: [0, 1],
                )
                
          ),
        );
  }
}