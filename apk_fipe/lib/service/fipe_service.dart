import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class FipeService {
  final header = {
      'Content-Type': 'application/json',
      'content-type': 'application/json',
      'X-Subscription-Token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIwMGE1MjJkYi01MmE5LTQwNDYtYjcwMS1hMzFhODdkYjY0NjEiLCJlbWFpbCI6Imd1aWxoZXJtZXRyYWphbm9za2lAZ21haWwuY29tIiwiaWF0IjoxNzU5MjgyNTE5fQ.TyIatQfadd9m5nTQUFp4isWYIJH_Dr7znZMYl1wTJEs'
  };

  Future<List<Map<String, dynamic>>> buscaMarcas() async {
    try {
      final uri = Uri.parse("https://fipe.parallelum.com.br/api/v2/cars/brands");
      final response = await http.get(uri, headers: header);
      if(response.statusCode == 200){
        return (json.decode(response.body) as List).cast<Map<String, dynamic>>();
      }
      else {
        throw Exception('Erro ${response.statusCode} : ${response.body}');
      }
    }on SocketException{
      throw Exception('Erro de conexão com a internet.');
    }catch(e){
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> buscaModelos(String marcaId) async {
    try {
      final uri = Uri.parse("https://fipe.parallelum.com.br/api/v2/cars/brands/$marcaId/models");
      final response = await http.get(uri, headers: header);
      if(response.statusCode == 200){
        return (json.decode(response.body) as List).cast<Map<String, dynamic>>();
      }
      else {
        throw Exception('Erro ${response.statusCode} : ${response.body}');
      }
    }on SocketException{
      throw Exception('Erro de conexão com a internet.');
    }catch(e){
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> buscaModelosMarcaAno(String marcaId, String anoId) async {
    try {
      final uri = Uri.parse("https://fipe.parallelum.com.br/api/v2/cars/brands/$marcaId/years/$anoId/models");
      final response = await http.get(uri, headers: header);
      if(response.statusCode == 200){
        return (json.decode(response.body) as List).cast<Map<String, dynamic>>();
      }
      else {
        throw Exception('Erro ${response.statusCode} : ${response.body}');
      }
    }on SocketException{
      throw Exception('Erro de conexão com a internet.');
    }catch(e){
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> buscaAnosModelo(String marcaId, String modeloId) async {
    try {
      final uri = Uri.parse("https://fipe.parallelum.com.br/api/v2/cars/brands/$marcaId/models/$modeloId/years");
      final response = await http.get(uri, headers: header);
      if(response.statusCode == 200){
        return (json.decode(response.body) as List).cast<Map<String, dynamic>>();
      }
      else {
        throw Exception('Erro ${response.statusCode} : ${response.body}');
      }
    }on SocketException{
      throw Exception('Erro de conexão com a internet.');
    }catch(e){
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> buscaAnosMarca(String marcaId) async {
    try {
      final uri = Uri.parse(
        "https://fipe.parallelum.com.br/api/v2/cars/brands/$marcaId/years",
      );
      final response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        return (json.decode(response.body) as List).cast<Map<String, dynamic>>();
      } else {
        throw Exception('Erro ${response.statusCode} : ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet.');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> buscaValorVeiculo(String marcaId, String modeloId, String ano) async {
    try {
      final uri = Uri.parse("https://fipe.parallelum.com.br/api/v2/cars/brands/$marcaId/models/$modeloId/years/$ano");
      final response = await http.get(uri, headers: header);
      if(response.statusCode == 200){
        return json.decode(response.body);
      }
      else {
        throw Exception('Erro ${response.statusCode} : ${response.body}');
      }
    }on SocketException{
      throw Exception('Erro de conexão com a internet.');
    }catch(e){
      rethrow;
    }
  }
}