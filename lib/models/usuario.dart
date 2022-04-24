// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    Usuario({
        required this.nombre,
        required this.email,
        required this.online,
        required this.uid,
    });

    String nombre;
    String email;
    bool online;
    String uid;

    //TENTEMOS LOS CONSTRUCTORES de quicktype
    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        nombre: json["nombre"],
        email: json["email"],
        online: json["online"],
        uid: json["uid"],
    );

    //TENTEMOS LOS CONSTRUCTORES de quicktype
    Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "email": email,
        "online": online,
        "uid": uid,
    };
}





// class Usuario {

//   //Propiedades de clase Usuario
//   late bool online;
//   late String email;
//   late String nombre;
//   late String uid;

//   //Constructor para facilitar su establecimiento.
//   Usuario(
//     this.online,
//     this.email,
//     this.nombre,
//     this.uid
//   );


// }