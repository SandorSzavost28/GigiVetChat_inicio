import 'package:chat_flutter01/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_flutter01/services/auth_service.dart';
import 'package:chat_flutter01/services/socket_service.dart';
import 'package:chat_flutter01/routes/routes.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // retorna la nueva instancia de AuthService (global), sirve como singleton, y para redibujar ante un cambio. 
        // AuthService estar[a disponible en el context ya que esta arriba]
        ChangeNotifierProvider(create: ( _ ) => ChatService() ),
        ChangeNotifierProvider(create: ( _ ) => AuthService() ) ,
        ChangeNotifierProvider(create: ( _ ) => SocketService() ) ,

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}