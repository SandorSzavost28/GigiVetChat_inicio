import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

mostrarAlerta(BuildContext context, String titulo, String subtitulo){

  if ( Platform.isAndroid ) {

    //android
      return showDialog(
        context: context, builder: (BuildContext context) => AlertDialog(
          title: Text( titulo),
          content: Text(subtitulo),
          actions: [
            MaterialButton(
              child: Text('Ok'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: ()=> Navigator.pop(context)
            )
          ],
        ), 
      );  
   } 

  showCupertinoDialog(
    context: context, 
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(titulo),
      content: Text(subtitulo),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('Ok'),
          onPressed: ()=> Navigator.pop(context),
        )
      ],
    )
  );


  

}