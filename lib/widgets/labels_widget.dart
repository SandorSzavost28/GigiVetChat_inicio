import 'package:flutter/material.dart';

class LabelsWidget extends StatelessWidget {
  // const LabelsWidget({ Key? key }) : super(key: key);

  final String ruta;
  final String askAccount;
  final String createOrLoginText;

  const LabelsWidget({
    Key? key, 
    required this.ruta, 
    required this.askAccount, 
    required this.createOrLoginText
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        
        children: <Widget>[
          Text(this.askAccount, style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),),
          SizedBox(height: 5,),
          
          GestureDetector(
            child: Text(this.createOrLoginText, style: TextStyle(color: Colors.blue[600], fontSize: 18, fontWeight: FontWeight.bold),),
            onTap: () {
              Navigator.pushReplacementNamed(context, this.ruta );
            },
          ),
          
          SizedBox(height: 5,),
          Text('Términos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w300),)
        ],
      ),
    );
  }
}