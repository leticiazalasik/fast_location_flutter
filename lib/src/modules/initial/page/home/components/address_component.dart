import 'package:flutter/material.dart';
import '../model/address_model.dart';

class AddressComponent extends StatelessWidget {
final AddressModel address;

const AddressComponent({
    super.key,
    required this.address, 
});

@override 
Widget build (BuildContext context) {
    return Card(
        child: ListTile(
            title: Text(address.logradouro),
            subtitle: Text('${address.localidade} - ${address.uf} - CEP: ${address.cep}'),
        )
    );
}

}