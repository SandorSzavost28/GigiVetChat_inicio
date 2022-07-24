import 'package:chat_flutter01/models/usuarios_response.dart';
import 'package:chat_flutter01/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:chat_flutter01/models/usuario.dart';
import 'package:chat_flutter01/global/environment.dart';

class UsuariosService{

  //metodo que regresara un Future y el future retornara una Lista de Usuarios
  Future<List<Usuario>> getUsuarios() async{

    String? token = await AuthService.getToken();
    
    try{


      //respuesta
      final resp = await http.get(Uri.parse('${ Environment.apiUrl}/usuarios'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token.toString()

        }
       
      );
      final usuariosResponse = usuariosReponseFromJson(resp.body);
      return usuariosResponse.usuarios;
      
    } catch(e) {
      return[];
    }
  
  }



}