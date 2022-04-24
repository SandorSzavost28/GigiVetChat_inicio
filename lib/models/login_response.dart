// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat_flutter01/models/usuario.dart';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    LoginResponse({
        required this.ok,
        required this.usuario,
        required this.token,
    });

    bool ok;
    Usuario usuario;
    String token;

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        usuario: Usuario.fromJson(json["usuario"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuario": usuario.toJson(),
        "token": token,
    };
}






// class Usuario {
//     Usuario({
//         required this.nombre,
//         required this.email,
//         required this.online,
//         required this.uid,
//     });

//     String nombre;
//     String email;
//     bool online;
//     String uid;

//     factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
//         nombre: json["nombre"],
//         email: json["email"],
//         online: json["online"],
//         uid: json["uid"],
//     );

//     Map<String, dynamic> toJson() => {
//         "nombre": nombre,
//         "email": email,
//         "online": online,
//         "uid": uid,
//     };
// }
