import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaBancas extends StatefulWidget {
  const TelaBancas({ Key? key }) : super(key: key);

  @override
  State<TelaBancas> createState() => _TelaBancasState();
}

class _TelaBancasState extends State<TelaBancas> {
  get child => null;
  //Declaração da coleção de Noticias
  var noticias;

  @override
  void initState(){
    super.initState();

    //Select de noticias
    noticias = FirebaseFirestore.instance
      .collection('bancas');
  }
  @override
  Widget build(BuildContext context) {
    String usuario = ModalRoute.of(context)!.settings.arguments == null ? "sem login":ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: Image.asset('lib/imagens/logoapp_q.png',), 
        automaticallyImplyLeading: false,
        flexibleSpace: Container(),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[


            TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, 'Feed', arguments: usuario);
              },
              child: const Text('Feed', style: TextStyle(color: Colors.blue),),
            ),
            TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, 'Lista', arguments: usuario);
              },
              child: const Text('Lista', style: TextStyle(color: Colors.blue),),
            ),
            TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, 'Bancas', arguments: usuario);
              },
              child: const Text('Bancas', style: TextStyle(
                color: Colors.white, 
                decoration: TextDecoration.underline,
                ),),
            ),
            TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, 'Sobre', arguments: usuario);
              },

              child: const Text('Sobre', style: TextStyle(color: Colors.blue),),
            ),
            IconButton(
                onPressed: (){Navigator.pushNamed(context, 'Favoritos',arguments: usuario);},
                icon: const Icon(Icons.favorite_border),
                color: Colors.blue,
            ),
            Column(
              children: [
                IconButton(
                      tooltip: 'sair',
                      onPressed: () {
                        //Faz logout do usuario
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, 'Login');
                      },
                      icon: const Icon(Icons.logout),
                    ),
                Text(
                  usuario,
                  style: const TextStyle(fontSize: 12),
                )
              ],
            ),
          ],
        ),
      ),


      body: Container(
        padding: const EdgeInsets.all(20),
        //
        //Exibir os documentos da coleção
        //
        child: StreamBuilder<QuerySnapshot>(
          //fonte de dados
          stream: noticias.snapshots(),
          builder: (context,snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
                return const Center(child: Text('Não foi possível conectar.'));
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                final dados = snapshot.requireData;
                return ListView.builder(
                  itemCount: dados.size,
                  itemBuilder: (context,index){
                    return Container(
                      height: 80,
                      child: Card(
                        child: ListTile(
                          
                          leading: Image.asset(dados.docs[index]['img'], height: 100, width: 100,),
                          trailing: const Icon(Icons.arrow_right),
                          title: Text(dados.docs[index]['banca'],),
                          textColor: Colors.grey.shade700,
                    
                          onTap: () {
                            Navigator.popAndPushNamed(
                              context,
                              'Feed',
                            );
                          },
                        ),
                      ),
                      margin: const EdgeInsets.all(10),
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}