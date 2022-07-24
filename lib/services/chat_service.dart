

import 'dart:io';

import 'package:chat_flutter01/global/environment.dart';
import 'package:chat_flutter01/models/mensajes_response.dart';
import 'package:chat_flutter01/models/usuario.dart';
import 'package:chat_flutter01/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  

  late Usuario usuarioPara;
  
  //set usuarioPara(Usuario usuarioPara) {}
  //Peticion a servicio de retornar mensajes
  //usuario Id del cual me interesa leer los mensajes
  Future<List<Mensaje>> getChat( String usuarioID ) async {

    String? token = await AuthService.getToken();

    //peticion http
    final url = Uri.parse('${Environment.apiUrl}/mensajes/$usuarioID');

    
    final resp = await http.get(url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token.toString()
      }
    );


    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensajes;

  }

}
