import 'package:mobx/mobx.dart';
import '../../initial/page/home/model/address_model.dart';
import '../../initial/page/home/repositories/local_repository.dart';

part 'history_controller.g.dart';

class HistoryController = _HistoryControllerBase with _$HistoryController;

abstract class _HistoryControllerBase with Store {
    final LocalRepository _localRepository = LocalRepository();

    @observable
    List<AddressModel> addresses = [];

    @action
    Future<void> loadAddresses()async {
final data = await _localRepository.getAddress();

if (data != null){
   addresses = [
  AddressModel(
          cep: data['cep'],
          logradouro: data['logradouro'],
          complemento: '',
          bairro: data['bairro'],
          localidade: '',
          uf: '',
          estado: '',
          regiao: '',
          ibge: '',
          gia: '',
          ddd: '',
          siafi: '',
        )
      ];
    }
  }
}
