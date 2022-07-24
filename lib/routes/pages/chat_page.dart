import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_flutter01/services/auth_service.dart';
import 'package:chat_flutter01/services/chat_service.dart';
import 'package:chat_flutter01/services/socket_service.dart';

import 'package:chat_flutter01/models/mensajes_response.dart';

import 'package:chat_flutter01/widgets/chat_message.dart';


class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() => _ChatPageState();
}
//se agrega el vertical sync para animacines
class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;


  //elementos para el chat
  List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //agregrmos los providers paporque necesitamos informacion para enviar el mensaje
    this.chatService    = Provider.of<ChatService>(context, listen: false);
    this.socketService  = Provider.of<SocketService>(context, listen: false);
    this.authService    = Provider.of<AuthService>(context, listen: false);
    //metodo para escuchar menesaje-personal
    this.socketService.socket.on('mensaje-personal', _escucharMensaje);

    //llamaremos metodo para llamar historial
    _cargarHistorial( this.chatService.usuarioPara.uid);
    
  }

  void _cargarHistorial( String usuarioID ) async {

    List<Mensaje> chat = await this.chatService.getChat(usuarioID);

    final history = chat.map((m) => ChatMessage(
      texto: m.mensaje, 
      uid: m.de, 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward()) ,
    );

    setState(() {
      _messages.insertAll(0, history);
    });

  }

  //metodo para sacer c[odigo de la eschucha
  void _escucharMensaje(dynamic payload){
    //print('Tengo Mensaje! $data');
    //esto lo va a insertar en los mensjaes pero tenemos que actualizar el state despues
    ChatMessage message = new ChatMessage(
      texto: payload['mensaje'], 
      uid: payload['de'], 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300)));

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();

  }


  @override
  Widget build(BuildContext context) {

    //importar servicio, eliminamos la linea porque ya inicializamis en el initState c114
    //final chatService = Provider.of<ChatService>(context);

    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                child: Text(usuarioPara.nombre.substring(0,2), style: TextStyle(fontSize: 12),),
                backgroundColor: Colors.lightBlueAccent,
                maxRadius: 14,
              ),
              SizedBox(height: 3,),
              Text(usuarioPara.nombre,style: TextStyle(color: Colors.black87, fontSize: 12),)
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

    //sabemos que recibimos el mensaje que escribe y comentamos la linea
    //print(texto);


    _textController.clear();
    _focusNode.requestFocus();

    //ANADIR ELEMENTO AL ARREGLO DE MENSAJES
    final newMessage = ChatMessage(
      uid: authService.usuario.uid,
      texto: texto, 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 400)), //disponible gracias al with TickerProviderStateMixin

    );
    _messages.insert(0, newMessage);
    //comenzar anuimacino
    newMessage.animationController.forward();

    //despues de dar un submit vuelve al estado _estaEscribiendo a falso
    setState(() {
      _estaEscribiendo = false;
    });

    //emitir mensaje al servidor
    this.socketService.emit('mensaje-personal',{
      'de': this.authService.usuario.uid,// remitente
      'para':this.chatService.usuarioPara.uid, //destinatario
      'mensaje':texto //texto
    });
    


  }

  //limpieza
  @override
  void dispose() {
    

    //instancias del arreglo de mensajes
    for ( ChatMessage message in _messages){
      message.animationController.dispose(); //limpia los anomation controller
    }

    // off del socket.. escucha del socket
    this.socketService.socket.off('mensaje-personal');

    super.dispose();
  }


}