import 'package:chat_flutter01/routes/pages/login_page.dart';
import 'package:chat_flutter01/routes/pages/usuarios_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_flutter01/services/auth_service.dart';

class LoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(

        //llamamos el Future que creamos abajo, con context para hacer la navegacion
        future: checkLoginState(context),

        builder: (context, snapshot) {  
          return Center( //envolvemos el cener en el Futiurebuilder porque necesitamos regresar algo
          child: Text('Espere...'),
           );
        },
        
      ),
   );
  }

  //creamos la respuesta future
  Future checkLoginState(BuildContext context) async{

    //instanciamos authService
    final authService = Provider.of<AuthService>(context,listen: false);

    //dependiendo de autenticado llamaremos a las pantallas   
    final autenticado = await authService.isLogggedIn();

    //llamar pantallas
    if (autenticado){

      //TODO: Conectar al socket service 3

      // Navigator.pushReplacementNamed(context, 'usuarios');
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: ( _, __, ___) => UsuariosPage(),
          transitionDuration: Duration(milliseconds: 0)
          //hacer animacion verificar curso de animaciones

        ),
      );

    } else {

      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: ( _, __, ___) => LoginPage(),
          transitionDuration: Duration(milliseconds: 0)
          //hacer animacion verificar curso de animaciones

        ),
      );

    }

  }

}