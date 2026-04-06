import 'package:fast_location/src/routes/app_routes.dart';
import 'package:fast_location/src/shared/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';

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

    // Garante que toda vez que a tela abrir, ela comece do zero
    controller.address = null;
    controller.error = '';

    //reacao de erro
    _disposer = reaction<String>((_) => controller.error, (error) {
      if (error.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
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
        title: InkWell(
          onTap: () {
            setState(() {
              controller.address = null;
              controller.error = '';
              cepController.clear();
            });
          },
          child: const Text('Home'),
        ),
        actions: [
          //histórico
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // acao de histórico
              Navigator.pushNamed(context, AppRoutes.history);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          //nova consulta
          SizedBox(
            width: 300,
            child: TextField(
              controller: cepController,
              onSubmitted: (value) {
                controller.fetchAddress(value, inputController: cepController);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Digite o CEP',
              ),
            ),
          ),

          //reatividade
          Expanded(
            child: Observer(
              builder: (_) {
                // 1. Loading "Bonito" e Centralizado
                if (controller.isLoading) {
                  return const Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ), // Ajusta a espessura da linha se desejar
                      ),
                    ),
                  );
                }

                // 2. Estado Vazio
                if (controller.address == null) {
                  return const EmptySearchComponent();
                }

                // 3. Resultado com o Botão Verde e Funcional
                return Column(
                  children: [
                    LastAddressComponent(address: controller.address!),
                    const SizedBox(
                      height: 20,
                    ), // Espaçamento entre o endereço e o botão

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.secondary, // Verde da Letícia
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        // AÇÃO DE ROTA
                        final address = controller.address!;
                        final destination = Uri.encodeComponent(
                          "${address.logradouro}, ${address.localidade} - ${address.uf}",
                        );
                        final url =
                            "https://www.google.com/maps/search/?api=1&query=$destination";

                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(
                            Uri.parse(url),
                            mode: LaunchMode.externalApplication,
                          );
                        }
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
