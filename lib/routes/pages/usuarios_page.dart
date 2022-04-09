import 'package:flutter/material.dart';
import 'package:chat_flutter01/models/usuario.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosPage extends StatefulWidget {



  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  
  final usuarios = [
    Usuario(true, 'mariatest1@hola.com', 'Maria', '1'),
    Usuario(true, 'josetest@hola.com','José','2'),
    Usuario(false, 'davidtest@hola.com','David', '3'),
    Usuario(true, 'fernandotest@hola.com','Fernando','4')
    
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text(
          'Mi nombre', 
          style: TextStyle( color: Colors.black54 ),
          // textAlign: TextAlign.center,
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){

          }, 
          icon: Icon(Icons.exit_to_app, color: Colors.black54,)
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10 ),
            child: Icon( Icons.check_circle, color: Colors.blue[400],),
            // child: Icon( Icons.offline_bolt, color: Colors.red,),

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
      );
  }

  _cargarUsuarios() async {
    //cargarar la ifnromacion del endpoint
    
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  


  }

}