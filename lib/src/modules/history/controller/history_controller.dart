import 'package:mobx/mobx.dart';
import '../../initial/page/home/model/address_model.dart';
import '../../initial/page/home/repositories/local_repository.dart';

part 'history_controller.g.dart';

// ignore: library_private_types_in_public_api
class HistoryController = _HistoryControllerBase with _$HistoryController;

abstract class _HistoryControllerBase with Store {
  final LocalRepository _localRepository = LocalRepository();

  @observable
  ObservableList<AddressModel> addresses = ObservableList<AddressModel>();

  @action
  Future<void> loadAddresses() async {
    final data = await _localRepository.getAllAddresses();
    addresses.clear();

    final list = data
        .map(
          (item) => AddressModel(
            cep: item['cep'] ?? '',
            logradouro: item['logradouro'] ?? '',
            localidade: item['localidade'] ?? '',
            uf: item['uf'] ?? '',
            bairro: item['bairro'] ?? '',
            complemento: item['complemento'] ?? '',
            estado: '',
            regiao: '',
            ibge: '',
            gia: '',
            ddd: '',
            siafi: '',
          ),
        )
        .toList();

    addresses.addAll(list);
  }

  @action
  Future<void> clearAll() async {
    await _localRepository.clearHistory();
    addresses
        .clear(); // Limpa a lista na memória (MobX cuidará da atualização da UI)
  }
}
