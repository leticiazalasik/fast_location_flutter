import 'package:flutter/material.dart';

class EmptySearchComponent extends StatelessWidget {
    const EmptySearchComponent ({super.key});

    @override
    Widget build (BuildContext context) {
        return const Center(
            child: Text(
                'Nenhum endereço pesquisado',
                style: TextStyle(fontSize: 16),
            ),
        );
    }
}