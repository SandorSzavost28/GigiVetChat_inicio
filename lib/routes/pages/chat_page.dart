import 'dart:io';

import 'package:chat_flutter01/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() => _ChatPageState();
}
//se agrega el vertical sync para animacines
class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscribiendo = false;

  //elementos para el chat
  List<ChatMessage> _messages = [
    // ChatMessage(texto: 'Hola Mundo1', uid: '123'),
    // ChatMessage(texto: 'Hola Mundo2', uid: '123'),
    // ChatMessage(texto: 'Hola Mundo3', uid: '222444'),
    // ChatMessage(texto: 'Hola Mundo4', uid: '123'),
    // ChatMessage(texto: 'Hola Mundo5', uid: '222444'),
    // ChatMessage(texto: 'Hola Mundo6', uid: '123')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                child: Text('Us', style: TextStyle(fontSize: 12),),
                backgroundColor: Colors.lightBlueAccent,
                maxRadius: 14,
              ),
              SizedBox(height: 3,),
              Text('Usuario Perez',style: TextStyle(color: Colors.black87, fontSize: 12),)
            ],
          ),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: ( _ , i ) => _messages[i],
                reverse: true,

              ),

            ),
            Divider( height: 1,),

            //TODO: caja de texto
            Container(
              // color: Colors.lightBlueAccent,
              height: 80,
              child: _inputChat(),

            )
          ],
        ),
      ),
   );
  }

  //Input para escribir y enviar mensaje
  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: ( String texto){
                  //TODO: Valida cuando hay un valor para poder postear
                  setState(() {
                    if (texto.trim().length > 0) {
                      _estaEscribiendo = true;
                    } else{
                      _estaEscribiendo = false;
                    }

                  });

                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                  
                ),
                focusNode: _focusNode,
              )
            ),
            //boton de enviar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS //uso de ternario
              ? CupertinoButton(
                child: Text('Enviar'), 
                onPressed: _estaEscribiendo //uso de ternario
                    ? () => _handleSubmit(_textController.text.trim())
                    : null, 
              )
              : Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconTheme(
                  data: IconThemeData(
                    color: Colors.blue[400]
                  ),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon(
                      Icons.send, 
                      // color: Colors.blue,
                    ),
                    //onPressed: (){}, 
                    onPressed: _estaEscribiendo //uso de ternario para validar si el icono esta habilitado o no 
                    ? () => _handleSubmit(_textController.text.trim())
                    : null, 
                  ),
                ),
              )
              ,
            )


          ],
        ),
      ) 
    );

  }

  //metodo para obtener el texto de la caja
  _handleSubmit(String texto){

    //validacion texto vacio sin enter en chat
    if (texto.isEmpty) return;


    print(texto);
    _textController.clear();
    _focusNode.requestFocus();

    //ANADIR ELEMENTO AL ARREGLO DE MENSAJES
    final newMessage = ChatMessage(
      texto: texto, 
      uid: '123',
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 400)), //disponible gracias al with TickerProviderStateMixin

    );
    _messages.insert(0, newMessage);
    //comenzar anuimacino
    newMessage.animationController.forward();

    //despues de dar un submit vuelve al estado _estaEscribiendo a falso
    setState(() {
      _estaEscribiendo = false;
    });

    
    


  }

  //limpieza
  @override
  void dispose() {
    // TODO: off del socket.. escucha del socket

    //instancias del arreglo de mensajes
    for ( ChatMessage message in _messages){
      message.animationController.dispose(); //limpia los anomation controller
    }



    super.dispose();
  }


}