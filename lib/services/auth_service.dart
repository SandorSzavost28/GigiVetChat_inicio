import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_flutter01/global/environment.dart';
import 'package:chat_flutter01/models/login_response.dart';
import 'package:chat_flutter01/models/usuario.dart';

class AuthService with ChangeNotifier{

  // usuario actualemente logueado, haremos refenrecikla al authseevidew
  late Usuario usuario;

  //secure storage para el token, _privado
  final _storage = new FlutterSecureStorage();
  
  //para dehabilitar el boton Login
  //propiedad que cambiaremos de acuerdo al estado de la autenticacion o logueo
  //privada, crearemos getters y setters, para notificar a los listeners
  bool _isLoging = false;
  //getter
  bool get isLoging => this._isLoging; //va a devolver el estado de la propiedad _isLoging
  //setter
  set isLoging (bool valor){
    this._isLoging = valor;
    //notififacion a los listeners
    notifyListeners();
  }

  //Getters y setters estaticos para acceder al token fuera del provider, asi AuthService.token
  //Metodos estaticos
  //future porque hay quye esperar, no es sincrono
  static Future<String?> getToken() async{
    //no tenemos acceso al storage porque es estatica, entonces lo instanciamos aqui adedntro
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
    
  }
  //borrar token
  static Future<void> deleteToken() async{
    //no tenemos acceso al storage porque es estatica, entonces lo instanciamos aqui adedntro
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
    //return token;
    
  }


  //Login

  //agregamos el <bool> para retornar true si lo hace correctamente y false si hay algo mal
    // Método que retornara un Future y se llamara login, recibe, email y password
  Future<bool>login(String email, String password) async {

    this.isLoging = true;
    //trabajeremos el payload que enviaremos al backend en la peticion POST
    final data = {
      'email' : email,
      'password' : password
    }; // campos nombrados de acuerdo a los campos del backedn

    //correccion de la clase, para parsear el Uri
    final uri = Uri.parse('${ Environment.apiUrl }/login');

    //resp sera la respuesta de la petcion HTTP Post al login del backend
    final resp = await http.post(
      uri, 
      body: jsonEncode(data), //aqui va usuario y contra
      headers: {
        'Content-type' : 'application/json'
      }
    );
  
    //imprime la respuesta, de la peticion login
     //print ( resp.body);

    this.isLoging = false;    

    //validacion de respuesta correcta, de acuerdo al statusCode
    if (resp.statusCode == 200 ){
      //lo almacenamos en 
      final loginResponse = loginResponseFromJson(resp.body);
      // ya tenemos disponibles
      // loginResponse.ok;  // loginResponse.token; // loginResponse.usuario;

      //voy almacenar aqui el usuario 
      this.usuario  = loginResponse.usuario;

      //TODO: Guarada token en luyhar seguro
      await _guardarToken(loginResponse.token);

      //si todo fue correcto returna un true para indicar que prosiga a la siguiente pantalla, BlueButton en Login_page
      return true;

    } else {
      
      //podemos personalizar de acuerdo al error que recibimos en el resp.body
      //si hubo algun error
      return false;
    }
  }

  // Register (TAREA) //future que regresa booloeano o string v97 6:30
  Future register (String nombre, String email, String password) async {

    this.isLoging = true;
    //trabajeremos el payload que enviaremos al backend en la peticion POST
    //tarea se agrego para el register
    final data = {
      'nombre'    : nombre,
      'email'     : email,
      'password'  : password
    }; // campos nombrados de acuerdo a los campos del backedn

    //correccion de la clase, para parsear el Uri / ruta del login / login/new peticion postman
    final uri = Uri.parse('${ Environment.apiUrl }/login/new');

    //resp sera la respuesta de la petcion HTTP Post al login del backend
    final resp = await http.post(
      uri, 
      body: jsonEncode(data), //aqui va usuario y contra
      headers: {
        'Content-type' : 'application/json'
      }
    );
  
    //imprime la respuesta, de la peticion login
    //  print ( resp.body);

    this.isLoging = false;    

    //validacion de respuesta correcta, de acuerdo al statusCode
    if (resp.statusCode == 200 ){
      //lo almacenamos en 
      final registerResponse = loginResponseFromJson(resp.body);
      // ya tenemos disponibles
      // loginResponse.ok;  // loginResponse.token; // loginResponse.usuario;

      //voy almacenar aqui el usuario 
      this.usuario  = registerResponse.usuario;

      //TODO: Guarada token en luyhar seguro
      await _guardarToken(registerResponse.token);

      //si todo fue correcto returna un true para indicar que prosiga a la siguiente pantalla, BlueButton en Login_page
      return true;

    } else {
      
      //decodificar para tener el mensaje, mapea un json strin a una mapa
      final respBody = jsonDecode(resp.body);

      //podemos personalizar de acuerdo al error que recibimos en el resp.body
      //si hubo algun error muestra mensaje //Register
      return respBody['msg'];
    }


  }

  //validacion de token 
  Future<bool> isLogggedIn() async{

    //*
    // late dynamic resp;

    //leo el tocken almacenado en el secure storage
    final token = await this._storage.read(key: 'token');

    // //validacion David
    // if (token == null){
    //   final url = Uri.parse('${ Environment.apiUrl }/login/renew');
    //   resp = await http.get(url);      
    // } else {
    //   final url = Uri.parse('${ Environment.apiUrl }/login/renew');
    //   resp = await http.get(
    //     url,
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'x-token': token
    //   }
        
    //   );
    // }
  
    
    
    
    //validacion David
    if (token == null){
      return false;
    }


    final uri = Uri.parse('${ Environment.apiUrl }/login/renew');
    //print(token); endpoint token renew
    final resp = await http.get(
      uri, 
      // body: jsonEncode(data), //aqui va usuario y contra
      headers: {
        'Content-type'  : 'application/json',
        'x-token'       : token,
      }
    );
  
    //imprime la respuesta, de la peticion login
    //  print ( resp.body);

    

    //validacion de respuesta correcta, de acuerdo al statusCode 
    //TOKEN VALIDO
    if (resp.statusCode == 200 ){
      //lo almacenamos en 
      final registerResponse = loginResponseFromJson(resp.body);
      // ya tenemos disponibles
      // loginResponse.ok;  // loginResponse.token; // loginResponse.usuario;

      //voy almacenar aqui el usuario 
      this.usuario  = registerResponse.usuario;

      //TODO: Guarada token en luyhar seguro
      await _guardarToken(registerResponse.token);

      //si todo fue correcto returna un true para indicar que prosiga a la siguiente pantalla, BlueButton en Login_page
      return true;

    } else { 
      //TOKEN INVALIDO 
      this.logout(); //para borrar token

      return false;

    }

  }


  //guardar token
  Future _guardarToken ( String token ) async {
    //escribir
    return await _storage.write(key: 'token', value: token);
  }

  //creacion del logout para la eliminacion del token
  Future logout()async{

    await _storage.delete(key: 'token');

  }

}