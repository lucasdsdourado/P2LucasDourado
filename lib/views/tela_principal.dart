import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/noticias.dart';
import 'package:flutter/material.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({ Key? key }) : super(key: key);

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  get child => null;
  //Declaração da coleção de Noticias
  var noticias;

  // Declaracao que armazenará o nome do usuario selecionado no banco
  var nomeUsuario;

  @override
  void initState(){
    super.initState();

    //Select de noticias
    noticias = FirebaseFirestore.instance
      .collection('noticias');
  }
  @override
  Widget build(BuildContext context) {

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
                Navigator.popAndPushNamed(context, 'Feed', arguments: nomeUsuario);
              },
              child: const Text('Feed', style: TextStyle(
                color: Colors.white, 
                decoration: TextDecoration.underline,
                ),),
            ),
            TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, 'Lista', arguments: nomeUsuario);
              },
              child: const Text('Lista', style: TextStyle(color: Colors.blue),),
            ),
            TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, 'Bancas', arguments: nomeUsuario);
              },
              child: const Text('Bancas', style: TextStyle(color: Colors.blue),),
            ),
            TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, 'Sobre', arguments: nomeUsuario);
              },
              child: const Text('Sobre', style: TextStyle(color: Colors.blue),),
            ),
            IconButton(
                onPressed: (){Navigator.pushNamed(context, 'Favoritos', arguments: nomeUsuario);},
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
                  //
                  // Retornar o nome do usuario
                  //
                FutureBuilder(
                  future: retornarUsuarioLogado(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      return Text(
                        nomeUsuario ?? '',
                        style: const TextStyle(fontSize: 12),
                      );
                    }
                  },
                ),
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
    String banca = item.data()['banca'];
    String conteudo = item.data()['conteudo'];
    String datanoticia = item.data()['datanoticia'];
    String img = item.data()['img'];
    String titulo = item.data()['titulo'];



    return WidgetNoticias(
      img,
      banca,
      datanoticia,
      titulo,
      conteudo,
      item.id,
    );
  }
  retornarUsuarioLogado() async{
    var uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
      .collection('usuarios')
      .where('uid', isEqualTo: uid)
      .get()
      .then((q) {
        if (q.docs.isNotEmpty){
          nomeUsuario = q.docs[0].data()['nome'];
        }else{
          nomeUsuario = "NENHUM";
        }
      }
    );
  }
}