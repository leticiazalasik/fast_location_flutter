import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import '../model/address_model.dart';
import '../service/address_service.dart';

part 'home_controller.g.dart';

// ignore: library_private_types_in_public_api
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final AddressService _service = AddressService();

  //estado
  @observable
  AddressModel? address;

  @observable
  bool isLoading = false;

  @observable
  String error = '';

  //acao
  @action
  Future<void> fetchAddress(
    String cep, {
    required TextEditingController inputController,
  }) async {
    try {
      isLoading = true;
      error = '';
      address = null;

      final result = await _service.getAddress(cep);

      if (result != null) {
        address = result;
        inputController.clear();
      } else {
        error = 'CEP não encontrado';
      }
    } catch (e) {
      error = "Erro ao buscar CEP";
    } finally {
      isLoading = false;
    }
  }


  //action para busca de cep 
 @action
 Future<void> searchAddress({
  required String uf,
  required String cidade,
  String? logradouro,
  }) async {
    try {
      if (uf.trim().isEmpty || cidade.trim().isEmpty) {
      error = 'UF e cidade são obrigatórios';
      return;
      }

    isLoading = true;
    error = '';
    address = null;

    final result = await _service.searchAddress(
      uf: uf.trim(),
      cidade: cidade.trim(),
      logradouro: logradouro?.trim(),
    );
    if (result != null) {
      address = result;
    } else {
      error = 'Nenhum endereço encontrado';
    }
  } catch (e) {
    error = 'Erro ao buscar endereço';
  } finally {
    isLoading = false;
  }
}
}
