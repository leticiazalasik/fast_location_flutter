import 'package:fast_location/src/routes/app_routes.dart';
import 'package:fast_location/src/shared/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/home_controller.dart';
import '../components/empty_search_component.dart';
import '../components/address_component.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variáveis de estado da tela
  final HomeController controller = HomeController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController ufController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController logradouroController = TextEditingController();

  late ReactionDisposer _disposer;

  //estado inicial
  @override
  void initState() {
    super.initState();

    // Garante que toda vez que a tela abrir, ela comece do zero
    controller.address = null;

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          bottom: TabBar(
            tabs: [
              Tab(text: "Pesquisar com CEP"),
              Tab(text: "Pesquisar com Endereço"),
            ],
          ),
        ),
        body: Column(
          children: [
            // No build da HomePage
            SizedBox(
              height: 250, // Altura fixa para os formulários
              child: TabBarView(
                children: [
                  // ABA 1: CEP
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: cepController,
                          decoration: const InputDecoration(
                            labelText: 'Digite o CEP',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _buscarPorCep(cepController.text),
                          child: const Text("Pesquisar CEP"),
                        ),
                      ],
                    ),
                  ),
                  // ABA 2: Endereço (3 Campos)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller:
                              logradouroController, // Crie este controller no initState
                          decoration: const InputDecoration(
                            labelText: 'Logradouro',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller:
                                    ufController, // Crie este controller
                                decoration: const InputDecoration(
                                  labelText: 'UF',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller:
                                    cidadeController, // Crie este controller
                                decoration: const InputDecoration(
                                  labelText: 'Cidade',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _buscarPorEndereco,
                          child: const Text("Pesquisar Endereço"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

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
                  if (controller.address == null) {
                    return const EmptySearchComponent();
                  } else {
                    return Column(
                      children: [
                        AddressComponent(address: controller.address!),
                        const SizedBox(
                          height: 20,
                        ), // Espaçamento entre o endereço e o botão

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.secondary, // Verde da Letícia
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _abrirRota,
                          child: const Text('Traçar rota'),
                        ),
                      ],
                    );
                  }

                  // 3. Resultado com o Botão Verde e Funcional
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _buscarPorCep(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanValue.length == 8) {
      controller.fetchAddress(
        cleanValue,
        inputController: cepController,
      ); // Busca direta por CEP
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('CEP deve ter 8 dígitos')));
    }
  }

  void _buscarPorEndereco() {
    final uf = ufController.text.trim().toUpperCase();
    final cidade = cidadeController.text.trim();
    final logradouro = logradouroController.text.trim();

    if (uf.length == 2 && cidade.length >= 3 && logradouro.length >= 3) {
      controller.searchAddress(uf: uf, cidade: cidade, logradouro: logradouro);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Preencha os campos corretamente (UF com 2 letras, Cidade/Rua com +3)',
          ),
        ),
      );
    }
  }

  Future<void> _abrirRota() async {
    final address = controller.address!;
  final destinationAddress = "${address.logradouro}, ${address.localidade} - ${address.uf}";

  try {
    // 1. Validar e solicitar permissão de GPS
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 2. Pegar localização atual (Origem)
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    // 3. Converter endereço pesquisado em coordenadas (Destino)
    List<Location> locations = await locationFromAddress(destinationAddress);
    if (locations.isEmpty) throw 'Endereço não encontrado';
    
    Location dest = locations.first;

    // 4. Montar URL para o Navegador com Origem e Destino
    // saddr = source address (origem) | daddr = destination address (destino)
    final String url = "https://www.google.com/maps/dir/?api=1"
        "&origin=${currentPosition.latitude},${currentPosition.longitude}"
        "&destination=${dest.latitude},${dest.longitude}"
        "&travelmode=driving";

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Se falhar o app, tenta forçar no navegador
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }

  } catch (e) {
    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao traçar rota: $e')),
    );
  }
  }
}
