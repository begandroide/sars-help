//import '../models/item_model.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

const host = '127.0.0.1:8000';

class ApiProvider {
  fetchPosts() async {
	final response = await http.get(host + '/api/users/getAll/');
    ItemModel itemModel = ItemModel.fromJson(json.decode(response.body));
    return itemModel;
  }
}

class ItemModel{
  String _idProducto;
  String _plu;
  String _descripcion;
  String _costoReal;

  ItemModel(this._idProducto,this._plu,this._descripcion,this._costoReal);

  ItemModel.fromJson(Map<String,dynamic> parsedJson){
    _idProducto = parsedJson['db']['id_producto'];
    _plu = parsedJson['db']['plu'];
    _descripcion= parsedJson['db']['descripcion'];
    _costoReal = parsedJson['db']['costo_real'];
  }

  String get idProducto => _idProducto;

  String get plu => _plu;

  String get descripcion => _descripcion;

  String get costoReal => _costoReal;

}