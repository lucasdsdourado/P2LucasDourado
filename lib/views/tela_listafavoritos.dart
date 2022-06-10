import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListaFavorito extends StatefulWidget {
  const ListaFavorito({ Key? key }) : super(key: key);

  @override
  State<ListaFavorito> createState() => _ListaFavoritoState();
}

class _ListaFavoritoState extends State<ListaFavorito> {
  get child => null;
  //Declaração da coleção de Favoritos
  var favoritos;

  @override
  void initState(){
    super.initState();

    //Select de noticias
    favoritos = FirebaseFirestore.instance
      .collection('favoritos')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
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
                color: Colors.blue,
                ),),
            ),
            TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, 'Sobre', arguments: usuario);
              },

              child: const Text('Sobre', style: TextStyle(color: Colors.blue),),
            ),
            IconButton(
                onPressed: (){Navigator.pushNamed(context, 'Favoritos', arguments: usuario);},
                icon: const Icon(Icons.favorite),
                color: Colors.white,
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
        padding: const EdgeInsets.all(50),
        //
        //Exibir os documentos da coleção
        //
        child: StreamBuilder<QuerySnapshot>(
          //fonte de dados
          stream: favoritos.snapshots(),
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
                    return exibirDocumento(dados.docs[index]);
                  },
                );
            }
          },
        ),
      ),
    );
  }
  exibirDocumento(item){
    String titulo = item.data()['titulo'];
    String anotacao = item.data()['notefavorito'];
    return ListTile(
      title: Text(titulo),
      subtitle: Text(anotacao),
      
      //REMOVER UM DOCUMENTO
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: (){

          FirebaseFirestore.instance
            .collection('favoritos').doc(item.id).delete();

        },
      ),
      //PASSAR COMO ARGUMENTO O id do documento
      onTap: () {
        Navigator.pushNamed(context, 'Favoritar', arguments: item.data()['docnoticia']);
      },
    );
  }
}