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
  Future<List<AddressModel>> searchAddress({
    required String uf, 
    required String cidade, 
    String? logradouro, 
      }) async {
        try{
          final encodedCidade = Uri.encodeComponent(cidade);
          final encodedLogradouro = Uri.encodeComponent(logradouro ?? '');
          final response = await DioClient.dio.get(
          '$uf/$encodedCidade/${encodedLogradouro.isEmpty ? '' : encodedLogradouro}/json/'
          );
             if (response.data == null || response.data is! List) {
        return [];
      }


      final dataList = response.data as List;

      if (dataList.isEmpty) {
        return [];
      }

      return dataList.map((item) {
        return AddressModel(
            cep:item['cep'],
            logradouro: item['logradouro'],
                complemento: item['complemento'] ?? '',
                bairro: item['bairro'],
                localidade: item['localidade'],
                uf: item['uf'],
                estado: item['estado'],
                regiao: item['regiao'],
                ibge: item['ibge'],
                gia: item['gia'],
                ddd: item['ddd'],
                siafi: item['siafi'],
         );
      }).toList();
    } catch (e) {
      throw Exception('Falha ao buscar endereço');
    }
  }
}
