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

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Histórico'),
        content: const Text('Deseja apagar todas as consultas salvas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              controller.clearAll();
              Navigator.pop(context);
            },
            child: const Text('Limpar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // lib/src/modules/history/page/history_page.dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _confirmClear(context),
            tooltip: 'Limpar Histórico',
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          // Se a lista estiver vazia, mostra o componente de busca vazia
          if (controller.addresses.isEmpty) {
            return const EmptySearchComponent();
          }

          // Utiliza o componente padronizado para listar os endereços
          return ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: AddressListComponent(
              addresses: controller.addresses,
            ),
          );
        },
      ),
    );
  }
}
