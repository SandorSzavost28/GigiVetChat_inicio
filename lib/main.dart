import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_flutter01/routes/routes.dart';
import 'package:chat_flutter01/services/auth_service.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // retorna la nueva instancia de AuthService (global), sirve como singleton, y para redibujar ante un cambio. 
        // AuthService estar[a disponible en el context ya que esta arriba]
        ChangeNotifierProvider(create: ( _ ) => AuthService() ) 
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