import 'package:flutter/material.dart';
import '../model/address_model.dart';

class AddressListComponent extends StatelessWidget {
    final List<AddressModel> addresses;

    const AddressListComponent({
        super.key,
        required this.addresses,
    });

    @override
    Widget build(BuildContext context){
        return ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (_, index) {
            final address = addresses[index];

            return ListTile(
                title: Text(address.logradouro),
                subtitle: Text('${address.localidade} - ${address.uf}'),
                );
            }
        );
    }
}