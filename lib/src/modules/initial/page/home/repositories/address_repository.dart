import '../../../../../http/dio_client.dart';
import '../model/address_model.dart';

class AddressRepository {

    Future <AddressModel> getAddress(String cep) async {
        final response = await DioClient.dio.get('$cep/json/');

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
  }
}
  
