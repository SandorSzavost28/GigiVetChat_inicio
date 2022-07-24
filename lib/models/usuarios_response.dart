// To parse this JSON data, do
//
//     final usuariosReponse = usuariosReponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat_flutter01/models/usuario.dart';

UsuariosReponse usuariosReponseFromJson(String str) => UsuariosReponse.fromJson(json.decode(str));

String usuariosReponseToJson(UsuariosReponse data) => json.encode(data.toJson());

class UsuariosReponse {
    UsuariosReponse({
        required this.ok,
        required this.usuarios,
    });

    bool ok;
    List<Usuario> usuarios;

    factory UsuariosReponse.fromJson(Map<String, dynamic> json) => UsuariosReponse(
        ok: json["ok"],
        usuarios: List<Usuario>.from(json["usuarios"].map((x) => Usuario.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
    };
}

