import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

class CustomButton extends StatelessWidget {
    final String text;
    final VoidCallback onPressed;

    const CustomButton({
        super.key,
        required this.text,
        required this.onPressed,
    });

    @override
    Widget build(BuildContext context){
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, 
            ), 
            onPressed: onPressed, 
            child: Text(text),
        );
    }
}