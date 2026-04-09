import '../repositories/address_repository.dart';
import '../repositories/local_repository.dart';
import '../model/address_model.dart';

class AddressService {
  final AddressRepository _addressRepository = AddressRepository();
  final LocalRepository _localRepository = LocalRepository();

  Future<AddressModel?> getAddress(String cep) async {
    final cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanCep.length != 8) {
      throw Exception('CEP Inválido');
    }

    //Buscar da api
    final address = await _addressRepository.getAddress(cleanCep);

    await _localRepository.saveAddress(address);

    return address;
  }

  Future<AddressModel?> searchAddress({
    required String uf,
    required String cidade,
    String? logradouro,
  }) async {
    if (uf.isEmpty || cidade.isEmpty) {
      throw Exception('UF e cidade são obrigatórios');
    }
    final result = await _addressRepository.searchAddress(
      uf: uf,
      cidade: cidade,
      logradouro: logradouro ?? '',
    );

    if (result != null) {
      await _localRepository.saveAddress(result);
    }

    return result;
  }
}
