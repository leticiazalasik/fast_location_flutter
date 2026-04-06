import 'package:hive/hive.dart';
import '../model/address_model.dart';

class LocalRepository {
  final String _boxName = 'addressBox';

  Future<void> saveAddress(AddressModel? address) async {
    if (address == null) {
      return;
    }
    final box = await Hive.openBox(_boxName);

    final addressMap = {
      'cep': address.cep ?? '',
      'logradouro': address.logradouro ?? '',
      'localidade': address.localidade ?? '',
      'uf': address.uf ?? '',
      'bairro': address.bairro ?? '',
      'complemento': address.complemento ?? '',
      'estado': '',
      'regiao': '',
      'ibge': '',
      'gia': '',
      'ddd': '',
      'siafi': '',
    };

    await box.add(addressMap);
  }

  Future<List<Map<dynamic, dynamic>>> getAllAddresses() async {
    final box = await Hive.openBox(_boxName);

    return box.values.cast<Map<dynamic, dynamic>>().toList().reversed.toList();
  }

  Future<void> clearHistory() async {
    final box = await Hive.openBox(_boxName);
    await box.clear(); // Remove todos os itens da box
  }
}
