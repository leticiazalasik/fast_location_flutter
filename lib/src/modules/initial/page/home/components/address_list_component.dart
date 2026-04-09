import 'package:fast_location/src/modules/initial/page/home/components/address_component.dart';
import 'package:flutter/material.dart';
import '../model/address_model.dart';

class AddressListComponent extends StatelessWidget {
  final List<AddressModel> addresses;

  const AddressListComponent({super.key, required this.addresses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: addresses.length,
      itemBuilder: (_, index) {
        final address = addresses[index];

        return AddressComponent(address: address);
      },
    );
  }
}
