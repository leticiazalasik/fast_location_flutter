import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../controller/history_controller.dart';
import '../../initial/page/home/components/address_list_component.dart';
import '../../initial/page/home/components/empty_search_component.dart';

class HistoryPage extends StatefulWidget {
    const HistoryPage({super.key});

    @override 
    State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
final HistoryController controller = HistoryController();

@override
void initState() {
    super.initState();

    controller.loadAddresses();
}

@override
Widget build(BuildContext context) {
return Scaffold(
    appBar: AppBar(
        title: const Text('Histórico'),
    ),
    body: Observer(
        builder: (_) {
            if (controller.addresses.isEmpty){
                return const EmptySearchComponent();
            }

            return AddressListComponent(
                addresses: controller.addresses,
            );
        },
    ),
);

}
}
