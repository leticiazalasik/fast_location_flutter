import 'package:hive/hive.dart';
import '../model/address_model.dart';

class LocalRepository {
  Future<void> saveAddress(AddressModel? address) async {
    if (address == null) {
      return;
    }
    final box = await Hive.openBox('addressBox');

    await box.put('address', {
      'cep': address.cep,
      'logradouro': address.logradouro,
      'bairro': address.bairro,
    });
  }

  Future<Map?> getAddress() async {
    final box = await Hive.openBox('addressBox');

    return box.get('address');
  }
}
