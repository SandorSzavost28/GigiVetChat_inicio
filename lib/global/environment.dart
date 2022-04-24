//crearemos una clase que solo tendra metodos estaticos, acceder a ellos sin necesidad de instanciar la clase
//vaalidacion para iOS o Android, para rutas
import 'dart:io';

class Environment{
  //Servicios REST
  static String apiUrl    = Platform.isAndroid ? 'http://10.0.2.2:3000/api' : 'http://localhost:3000/api';
  //Servidor de Sockets
  static String socketUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';
}