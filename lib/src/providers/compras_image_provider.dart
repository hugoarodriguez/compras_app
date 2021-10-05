// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ComprasImageProvider{

  Future<bool> subirImagen(BuildContext context, String filePath) async {
    File file = File(filePath);//Archivo a guardar
    final String fileName = basename(filePath);//Nombre del archivo con su extensión, ej: imagen.png
    try{

      //Subida del archivo
      await firebase_storage.FirebaseStorage.instance.ref('images/$fileName').putFile(file);
      //Si la subida salió bien se retorna 'true'
      return true;
      
    } on firebase_storage.FirebaseException catch(e){
      //Si hubo error en la subida se retorna 'false'
      print(e);
      return false;

    }
  }
}