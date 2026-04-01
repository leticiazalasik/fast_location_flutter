import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../controller/home_controller.dart';
import '../components/empty_search_component.dart';
import '../components/last_address_component.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variáveis de estado da tela
  final HomeController controller = HomeController();
  final TextEditingController cepController = TextEditingController();

  late ReactionDisposer _disposer;

//estado inicial
  @override
  void initState() {
    super.initState();

    //reacao de erro
    _disposer = reaction<String>((_) => controller.error, (error) {
      if (error.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    });
  }

//Quando a tela fecha
  @override
  void dispose() {
    _disposer();
    cepController.dispose();
    super.dispose();
  }

//A tela em si
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          //histórico
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // acao de histórico
            },
          ),
        ],
      ),
      body: Column(
        children: [
          //nova consulta
          TextField(
            controller: cepController,
            onSubmitted: (value) {
            controller.fetchAddress(value);
            },
          ),

          //reatividade
          Expanded(
            child: Observer(
              builder: (_) {
                if (controller.isLoading) {
                  return const CircularProgressIndicator();
                }

                if (controller.address == null) {
                  return const EmptySearchComponent();
                }

                return Column(
                  children: [
                    LastAddressComponent(
                      address: controller.address!,
                    ),

                    ElevatedButton(
                      onPressed: () {
                        // ação de rota
                      },
                      child: const Text('Traçar rota'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}