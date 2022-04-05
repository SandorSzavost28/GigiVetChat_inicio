import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {

  final String text;
  final void Function()? onPressed;

  const BlueButton({
    Key? key, 
    required this.text, 
    required this.onPressed
    }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
            onPressed: this.onPressed,
            
            
              child: Container(
              width: double.infinity,
              height: 55,
              child: Center(
                child: Text(
                  this.text,
                  style: TextStyle( 
                    color: Colors.white,
                    fontSize: 17
                  ),
                  )
                ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shape: StadiumBorder(),
              


            ),


          );
  }
}