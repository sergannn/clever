import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double? width;
  final double? height;
  final bool isWhite;
  
  const Logo({
    super.key,
    this.width,
    this.height,
    this.isWhite = false,
  });

  @override
  Widget build(BuildContext context) {
    final logoWidth = width ?? 124.0;
    final logoHeight = height ?? 24.0;
    
    // Выбираем правильные изображения в зависимости от фона
    final cleverImage = isWhite 
        ? 'assets/images/logo_clever_white.png'
        : 'assets/images/logo_clever.png';
    final dotImage = isWhite
        ? 'assets/images/logo_dot_white.png'
        : 'assets/images/logo_dot.png';
    
    return SizedBox(
      width: logoWidth,
      height: logoHeight,
      child: Stack(
        children: [
          // "Clever" текст
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            right: logoWidth * 0.2641, // 26.41% справа для точки
            child: Image.asset(
              cleverImage,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback на текст, если изображение не загрузилось
                return Text(
                  'Clever',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: isWhite ? Colors.white : const Color(0xFF222222),
                  ),
                );
              },
            ),
          ),
          // Точка справа
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: logoHeight,
            child: Image.asset(
              dotImage,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback на символ, если изображение не загрузилось
                return Center(
                  child: Text(
                    '•',
                    style: TextStyle(
                      fontSize: 16,
                      color: isWhite ? Colors.white : const Color(0xFF222222),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

