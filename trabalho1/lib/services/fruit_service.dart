import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/fruit_model.dart';

class FruitService {
  final String baseUrl = 'https://api.api-onepiece.com/v2/fruits/en'; 

  Future<List<Fruit>> fetchFruits() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> fruitJson = jsonDecode(response.body);
        
        return fruitJson.map((json) => Fruit.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar frutas: ${response.statusCode}'); 
      }
    } catch (e) {
      throw Exception('Erro de rede: $e');
    }
  }

  Future<Fruit> fetchFruitDetails(int id) async {
    final detailUrl = '$baseUrl/$id';
    
    try {
      final response = await http.get(Uri.parse(detailUrl));

      if (response.statusCode == 200) {
        final fruitJson = jsonDecode(response.body);
        
        if (fruitJson is List && fruitJson.isNotEmpty) {
           return Fruit.fromJson(fruitJson.first);
        }

        return Fruit.fromJson(fruitJson);
      } else {
        throw Exception('Falha ao carregar detalhes da Akuma no Mi $id: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de rede ao buscar detalhes: $e');
    }
  }
}