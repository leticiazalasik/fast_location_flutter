import 'package:mobx/mobx.dart';
import '../model/address_model.dart';
import '../service/address_service.dart';

part 'home_controller.g.dart';

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
Future<void> fetchAddress(String cep) async {
    try{
        isLoading = true;
        error = '';

        address = await _service.getAddress(cep);

    } catch (e) {
    error = e.toString();
    } finally {
    isLoading = false;
    }
    
    }
}