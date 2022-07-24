import 'package:chat_flutter01/services/chat_service.dart';
import 'package:chat_flutter01/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_flutter01/services/socket_service.dart';
import 'package:chat_flutter01/services/auth_service.dart';

import 'package:chat_flutter01/models/usuario.dart';


class UsuariosPage extends StatefulWidget {



  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuarioService = new UsuariosService();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  //creamos lista de usuarios
  List<Usuario> usuarios = [];

  
  // final usuarios = [
  //   Usuario(online: true, email: 'mariatest1@hola.com', nombre: 'Maria', uid: '1'),
  //   Usuario(online: true, email: 'josetest@hola.com',nombre: 'José',uid: '2'),
  //   Usuario(online: false, email: 'davidtest@hola.com',nombre: 'David', uid: '3'),
  //   Usuario(online: true, email: 'fernandotest@hola.com',nombre: 'Fernando',uid: '4')  
  // ];

  //creamos el init para incluir el cargarusuarios al inicio
  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        
        title: Text(
          usuario.nombre, 
          style: TextStyle( color: Colors.black54 ),
          // textAlign: TextAlign.center,
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            
            //LOGOUT
            //TODO: desconectar del socket server
            socketService.disconnect();

            //sacar de la opantalla
            Navigator.pushReplacementNamed(context, 'login');

            //llamar al logout sin instanciar
            AuthService.deleteToken();
          }, 
          icon: Icon(Icons.exit_to_app, color: Colors.black54,)
        ),
        actions: <Widget>[
          Container(
                       
            margin: EdgeInsets.only(right: 10 ),
            
            child: (socketService.serverStatus == ServerStatus.Online )  
            ? Icon( Icons.check_circle, color: Colors.blue[400], ) //Online
            : Icon( Icons.offline_bolt, color: Colors.red,), //Offline

          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400],),
          waterDropColor: Colors.blue
        ),
        child: _listViewUsuarios(),
      ),
   );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      //efecto para rebote
      physics: BouncingScrollPhysics(

      ),

      itemBuilder: (_ , i) => _usuarioListTile( usuarios[i]), // context, indicce, y lo que va regresar 
      separatorBuilder: ( _ , i) => Divider(), 
      itemCount: usuarios.length
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
        title: Text( usuario.nombre ),
        subtitle: Text(usuario.email),
        leading: CircleAvatar(
          child: Text(
             usuario.nombre.substring(0,2)
          ),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            //uso de ternarios
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        onTap: () {
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.usuarioPara = usuario;
          Navigator.pushNamed(context, 'chat');
        },
      );
  }

  _cargarUsuarios() async {

    //crear instancia de Usuario
    

    //peticion y asignacion a propiedad de la clase
    this.usuarios = await usuarioService.getUsuarios();

    setState(() {
      
    });


    //cargarar la ifnromacion del endpoint
    
    // monitor network fetch
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  


  }

}