import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/mensagem.dart';

class InserirFavorito extends StatefulWidget {
  const InserirFavorito({Key? key}) : super(key: key);

  @override
  _InserirFavoritoState createState() => _InserirFavoritoState();
}

class _InserirFavoritoState extends State<InserirFavorito> {
  var txtTitulo = TextEditingController();
  var txtBanca = TextEditingController();
  var txtNote = TextEditingController();
  var temNote = false;
  var uid = FirebaseAuth.instance.currentUser!.uid;
  var idfavorito;
  
  //Retonar um documento pelo ID
  retornarDocumentoById(id) async{
    await FirebaseFirestore.instance
      .collection('noticias')
      .doc(id)
      .get()
      .then((doc) async {
        txtTitulo.text = doc.get('titulo');
        txtBanca.text = doc.get('banca');
        await FirebaseFirestore.instance
          .collection('favoritos')
          .where('docnoticia', isEqualTo: id,)
          .where('uid', isEqualTo: uid,) 
          .get()
          .then((q) {
            if (q.docs.isNotEmpty){
              txtNote.text = q.docs[0].data()['notefavorito'];
              idfavorito = q.docs[0].id;
              temNote = true;
            }
          });
          
      }); 
  }

  @override
  Widget build(BuildContext context) {

    // RECUPERAR O ID
    var id = ModalRoute.of(context)!.settings.arguments;
    if(id!=null){
      if(txtTitulo.text.isEmpty && txtBanca.text.isEmpty){
        retornarDocumentoById(id);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritar Notícia'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.all(50),
        child: ListView(
          children: [
            campoTexto('Título', txtTitulo, Icons.note, true),
            const SizedBox(height: 20),
            campoTexto('Banca', txtBanca, Icons.note, true),
            const SizedBox(height: 40),
            campoTexto('Anotação Favorito', txtNote, Icons.note, false),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    child: const Text('salvar'),
                    onPressed: () {               
                      if(temNote == false){       
                        //Adicionar um novo documento
                        FirebaseFirestore.instance
                          .collection('favoritos')
                          .add(
                            {
                              "uid" : FirebaseAuth.instance.currentUser!.uid,
                              "titulo" : txtTitulo.text,
                              "banca": txtBanca.text,
                              "notefavorito" : txtNote.text,
                              "docnoticia" : id,
                            }
                          );
                          sucesso(context, "Item adicionado com sucesso.");
                      } else{
                      //Altera o item
                      FirebaseFirestore.instance
                        .collection('favoritos')
                        .doc(idfavorito.toString())
                        .set(
                          {
                            "uid" : FirebaseAuth.instance.currentUser!.uid,
                            "titulo" : txtTitulo.text,
                            "banca": txtBanca.text,
                            "notefavorito" : txtNote.text,
                            "docnoticia" : id,
                          }
                        );
                        sucesso(context, "Item alterado com sucesso.");
                      }

                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 150,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      child: const Text('cancelar'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  campoTexto(texto, controller, icone, blockipt, {senha}) {
    return TextField(
      controller: controller,
      enabled: !blockipt,
      obscureText: senha != null ? true : false,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icone, color: Colors.grey.shade700),
        prefixIconColor: Colors.black,
        labelText: texto,
        fillColor: Colors.grey.shade300,
        filled: blockipt, 
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(),
        focusColor: Colors.black,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 0.0,
          ),
        ),
      ),
    );
  }
}
