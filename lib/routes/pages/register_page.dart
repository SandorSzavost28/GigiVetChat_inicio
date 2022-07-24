import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_flutter01/services/auth_service.dart';
import 'package:chat_flutter01/widgets/blue_button_widget.dart';  
import 'package:chat_flutter01/widgets/labels_widget.dart';
import 'package:chat_flutter01/widgets/logo_widget.dart';
import 'package:chat_flutter01/widgets/custon_input.dart';
import 'package:chat_flutter01/helpers/mostrar_alerta.dart';

import '../../services/socket_service.dart';


class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(), //efecto rebote
          child: Container(
            height: MediaQuery.of(context).size.height * 0.70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                LogoWidget(
                  titulo: 'Register',
                ),
        
                _Form(),
        
                LabelsWidget(
                  ruta: 'login',
                  askAccount: 'Ya tienes cuenta?',
                  createOrLoginText: 'Ingresa con tus datos',
                ),
                // _Labels(),
        
                // Text('Términos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w300),)
              ],
            ),
          ),
        ),
      ),
   );
  }
}


//Creacion de Seccion Media Formulario, sera un Stateful Widget

class _Form extends StatefulWidget {
  // _Form({Key? key}) : super(key: key);

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  //definimos los controladores de las cajas del formulario
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();


  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget> [
          
          // TextField(),
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Password',
            //keyboardType: TextInputType.emailAddress,
            textController: passCtrl,
            isPassword: true,
          ),

          //TODO crear boton
          BlueButton(
            //argumentos del boton azul
            text: 'Registrar',
            onPressed: authService.isLoging 
            ? null //si esta en TRUE esta autenticando y deshabilitara el boton
            : () async { //Si esta en FALSE estará habilitado

              //para deshabilitar el teclado al autenticar
              FocusScope.of(context).unfocus(); //quita el foco de donde sea que esté y oculta el teclado

              // print( emailCtrl.text);
              // print( passCtrl.text);
              
              //codigo movido arriba para elevarlo y hacerlo disponible mas arriba
              //Usaremos provider para llamar al AuthService.login
              // final authService = Provider.of<AuthService>(context,listen: false); //instancia del AuthService
              
              //asginammis al loginOK despues de agregar el bool y el async
              final registerOk = await authService.register( nameCtrl.text.trim() , emailCtrl.text.trim(), passCtrl.text.trim()); //trim para recortar los espacios al final

              if ( registerOk == true ) {

                // Conectar a sockets server
                socketService.connect();

                //cambiar de pantalla a logueado 
                //pushReplacementNamed porque no uqiero que regresen a la pantalla de login
                Navigator.pushReplacementNamed(context, 'usuarios'); 

            
              } else {
                //mmostrar alerta
                //vamos a extraer la logica de la alerta 
                mostrarAlerta(
                  context, 
                  'Registro incorrecto', //titulo
                  registerOk //subtitulo
                );

              }

            },
                        
          )


        ],
      ),
    );
  }
}
