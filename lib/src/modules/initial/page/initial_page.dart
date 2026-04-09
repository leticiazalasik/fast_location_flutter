import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';

class InitialPage extends StatefulWidget {
    const InitialPage({super.key});

    @override
    State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage>
    with SingleTickerProviderStateMixin {
        late AnimationController _controller;
        late Animation<double> _animation;

        @override
        void initState(){
                super.initState();

                _controller = AnimationController(
                    vsync: this, 
                    duration: const Duration(seconds: 2),
                );

            _animation = CurvedAnimation(
                parent: _controller,
                curve: Curves.easeIn,
            );

            _controller.forward();

            Future.delayed(const Duration(seconds:3), () {
              if(!mounted) return;
                Navigator.pushReplacementNamed( context, AppRoutes.home);
            });
        }

        @override
        void dispose(){
        _controller.dispose();
        super.dispose();
        }

    @override 
    Widget build(BuildContext context){
    return Scaffold(
    body: FadeTransition(
        opacity: _animation,
        child: Center(
        child: Text(
            'Fast Location',
            style: TextStyle(fontSize: 24),
            )
        )
    )
);
    }
}
    