import 'package:chat_flutter01/widgets/blue_button_widget.dart';
import 'package:chat_flutter01/widgets/labels_widget.dart';
import 'package:chat_flutter01/widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter01/widgets/custon_input.dart';


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
            text: 'Login',
            onPressed: (){
              print( emailCtrl.text);
              print( passCtrl.text);
            },

          )


        ],
      ),
    );
  }
}
