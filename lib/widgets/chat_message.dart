import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  
  //identificar si es texto mio o del otro usuario
  final String texto;
  final String uid;
  //animacion propiedad
  final AnimationController animationController;

  const ChatMessage({
    Key? key, 
    required this.texto, 
    required this.uid, 
    required this.animationController}) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition( //animacion del chat
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController, 
          curve: Curves.easeOut
        ),
        child: Container(
          child: this.uid == '123' //uso de ternario
          ? _myMessage()//Sisi es
          : _notMyMessage()//No es mi mensaje
          
          ,
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(20)
        ),
        padding: EdgeInsets.all(8.0),
        child: Text(this.texto, style: TextStyle( color: Colors.white),),
        margin: EdgeInsets.only(
          bottom: 5,
          left: 50,
          right: 5
        ),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE4E5E8 ),
          borderRadius: BorderRadius.circular(20)
        ),
        padding: EdgeInsets.all(8.0),
        child: Text(this.texto, style: TextStyle( color: Colors.black87),),
        margin: EdgeInsets.only(
          bottom: 5,
          left: 5,
          right: 50
        ),
      ),
    );
  }
}