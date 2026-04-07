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
    
    controller.addressList.clear();

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
              controller.addressList.clear();
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
                final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (cleanValue.length == 8) {
                  controller.fetchAddress(value, inputController: cepController);
                  return;
                }

                final normalized = value
                    .replaceAll(RegExp(r'\\s*[-;]\\s*'), ';')
                    .replaceAll(RegExp(r'\\s+'), ' ')
                    .trim();
                List<String> parts = normalized
                    .split(';')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                if (parts.length < 2 && normalized.isNotEmpty) {
                  final tokens = normalized
                      .split(' ')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();
                  if (tokens.length >= 2) {
                    parts = [
                      tokens[0],
                      tokens[1],
                      if (tokens.length > 2)
                        tokens.sublist(2).join(' '),
                    ];
                  }
                }

                if (parts.length < 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Use: UF;Cidade;Logradouro'),
                    ),
                  );
                  return;
                }

                final uf = parts[0].toUpperCase();
                final cidade = parts[1];
                final logradouro = parts.length >= 3 ? parts[2] : '';

                controller.searchAddress(
                  uf: uf,
                  cidade: cidade,
                  logradouro: logradouro,
                );
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CEP ou endereço: UF;Cidade;Logradouro',
              ),
            ),
          ),

          //reatividade
          Expanded(
            child: Observer(
              builder: (_) {
                if (controller.isLoading) {
                  return const Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ), 
                      ),
                    ),
                  );
                }

                // 2. Estado Vazio
if (controller.address == null && controller.addressList.isEmpty) {
                  return const EmptySearchComponent();
                }

if (controller.addressList.isNotEmpty) {
  return ListView.builder(
    itemCount: controller.addressList.length,
    itemBuilder: (_, index) {
      final item = controller.addressList[index];

      return ListTile(
        title: Text(item.logradouro),
        subtitle: Text("${item.localidade} - ${item.uf}"),
        trailing: Text(item.cep),
        onTap: () async {
          await controller.selectAddress(item);
        },
      );
    },
  );
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
                        final address = controller.address!;
                        final destination = Uri.encodeComponent(
                          "${address.logradouro}, ${address.localidade} - ${address.uf}",
                        );
                        final url =
                            "https://www.google.com/maps/dir/?api=1&destination=$destination";

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


