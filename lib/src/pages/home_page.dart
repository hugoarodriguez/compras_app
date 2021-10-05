// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unnecessary_null_comparison, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, avoid_print
import 'dart:io';
import 'package:compras_app/src/providers/compras_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File foto = File('');//Variable tipo File para la foto a subir
  ComprasImageProvider comprasImageProvider = ComprasImageProvider();//Clase con métodos para administrar imágenes

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase_core.Firebase.initializeApp(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          //Si hay error al inicializar la App
          return Center(child: CircularProgressIndicator(),);
        }

        if(snapshot.connectionState == ConnectionState.done){
          //Si la conexión fue exitosa
          return _mainScaffold();
        }

        //Si no se cumple ninguna de las condiciones
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  //Widget Scaffold que contiene los controles de la App
  Widget _mainScaffold(){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Compras App'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                mostrarFoto(),
                ElevatedButton(
                  child: Text('Subir'),
                  onPressed: () async {

                    if(foto.path != ''){
                      //Si la ruta de la imagen es distinta de ''
                      bool r = await comprasImageProvider.subirImagen(context, foto.path);

                      //Si el r == true indica que se guardó la imagen
                      if (r){
                        print('Guardado');
                      } else {
                        print('No se guardó');
                      }
                    }

                  },
                )
              ],
            ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_a_photo_rounded),
        onPressed: _seleccionarImagen,
      ),
    );
  }

  //Método de tipo Future para seleccionar la imagen de la galería
  Future _seleccionarImagen() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery
    );

    try{
      foto = File(pickedFile!.path);
      print('Ruta de imagen: ${foto.path}');
    } catch(e){
      print('$e');
    }

    if (foto.path == ''){
      print('No se seleccionó ninguna imagen');
    }
    
    setState(() { });
  }

  //Método Widget para mostrar la imagen seleccionada o una imagen pre-cargada al proyecto (si no se seleccionó ninguna foto) 
  Widget mostrarFoto(){
    return (foto.path != '')
    ?
    Image(
      image: FileImage(foto),
      height: 300.0,
      fit: BoxFit.cover,
    )
    :
    Image(
      image: AssetImage('assets/images/no-image.png'),
      height: 300.0,
      fit: BoxFit.cover,
    );
    
  }
}



