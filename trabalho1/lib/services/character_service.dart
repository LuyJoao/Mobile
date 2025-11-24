import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';
import '../models/character_detail_model.dart';

class CharacterService {
  final String listEndpoint = 'https://api.api-onepiece.com/v2/characters/en';
  final String baseUrl = 'https://api.api-onepiece.com/v2/characters/en';

  Future<List<Character>> fetchCharacters() async {
    try {
      final response = await http.get(Uri.parse(listEndpoint));

      if (response.statusCode == 200) {
        List<dynamic> characterJson = jsonDecode(response.body);
        
        return characterJson.map((json) => Character.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar personagens: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de rede: $e');
    }
  }
  
  Future<CharacterDetail> fetchCharacterDetails(int id) async {
    final detailUrl = '$baseUrl/$id';
    
    try {
      final response = await http.get(Uri.parse(detailUrl));

      if (response.statusCode == 200) {
        final characterJson = jsonDecode(response.body);
        
        if (characterJson is List && characterJson.isNotEmpty) {
           return CharacterDetail.fromJson(characterJson.first);
        }

        return CharacterDetail.fromJson(characterJson);
      } else {
        throw Exception('Falha ao carregar detalhes do personagem $id: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de rede ao buscar detalhes: $e');
    }
  }
}