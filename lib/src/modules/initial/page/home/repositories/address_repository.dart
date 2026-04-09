import '../../../../../http/dio_client.dart';
import '../model/address_model.dart';

class AddressRepository {
  Future<AddressModel?> getAddress(String cep) async {
    try {
      final response = await DioClient.dio.get('$cep/json/');

      if (response.data == null || response.data['erro'] == true) {
        return null;
      }

      return AddressModel(
        cep: response.data['cep'],
        logradouro: response.data['logradouro'],
        complemento: response.data['complemento'] ?? '',
        bairro: response.data['bairro'],
        localidade: response.data['localidade'],
        uf: response.data['uf'],
        estado: response.data['estado'],
        regiao: response.data['regiao'],
        ibge: response.data['ibge'],
        gia: response.data['gia'],
        ddd: response.data['ddd'],
        siafi: response.data['siafi'],
      );
    } catch (e) {
      throw Exception('Falha ao buscar CEP');
    }
  }

  //Método que busca cep por endereço
  Future<AddressModel?> searchAddress({
    required String uf,
    required String cidade,
    String? logradouro,
  }) async {
    try {
      final encodedCidade = Uri.encodeComponent(cidade);
      final encodedLogradouro = Uri.encodeComponent(logradouro ?? '');

      final uri = '$uf/$encodedCidade/${encodedLogradouro.isEmpty ? '' : encodedLogradouro}/json/';
      final response = await DioClient.dio.get(uri);



      if (response.data == null || response.data is! List) {
        return null;
      }

      final address = response.data[0];

      return AddressModel(
        cep: address['cep'],
        logradouro: address['logradouro'],
        complemento: address['complemento'] ?? '',
        bairro: address['bairro'],
        localidade: address['localidade'],
        uf: address['uf'],
        estado: address['estado'],
        regiao: address['regiao'],
        ibge: address['ibge'],
        gia: address['gia'],
        ddd: address['ddd'],
        siafi: address['siafi'],
      );
    } catch (e) {
      throw Exception('Falha ao buscar endereço');
    }
  }
}
