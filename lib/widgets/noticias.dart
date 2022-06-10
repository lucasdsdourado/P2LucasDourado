import 'package:flutter/material.dart';
import '../views/inserir_favoritos.dart';

class WidgetNoticias extends StatelessWidget {
  final String logo;
  final String nickname;
  final String datanoticia;
  final String titulo;
  final String descricao;
  final String id;

  const WidgetNoticias(this.logo, this.nickname, this.datanoticia, this.titulo, this.descricao, this.id, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      //height: 240,
      
      child: Column(
        children: [
                    
          SizedBox(
            width: double.infinity,
            child: Text(
              titulo,
              style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 10),


          SizedBox(
            width: double.infinity,
            child: Text(
              descricao.replaceAll("\\n", "\n"),
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),

          const SizedBox(height: 25),     
          
          Row(
            children: [
            TextButton(
              style: 
              ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.grey)
                  ),
                ),
              ),
              child: const Text('Lida', style: TextStyle(color: Colors.black),),
              onPressed: () {
                showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Notícia lida"),
                  content: const Text("Parabéns! Você acabou de ler esta notícia."),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Fechar"),
                    ),
                  ],
                ),
              );      
              },
            ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, 'Favoritar', arguments: id);
                },
                icon: const Icon(Icons.favorite_border)
              ),
              const SizedBox(width: 20),
              Text(nickname + ' | ' + datanoticia, 
                style: const TextStyle(
                  fontSize: 14, color: Colors.black,
                  ),
                ),
            ],
          ),
        
          const SizedBox(height: 60),
        ]
        
      ),
    );
  }

  void setState(Null Function() param0) {}

}
