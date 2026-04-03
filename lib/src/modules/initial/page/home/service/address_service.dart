import '../repositories/address_repository.dart';
import '../repositories/local_repository.dart';
import '../model/address_model.dart';

class AddressService {
final AddressRepository _addressRepository = AddressRepository();
final LocalRepository _localRepository = LocalRepository();

Future<AddressModel?> getAddress(String cep) async {
    final cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanCep.length !=8) {
        throw Exception('CEP Inválido');
    }

    //Buscar da api 
    final address = await _addressRepository.getAddress(cleanCep);

    await _localRepository.saveAddress(address);

    return address; 
}

}