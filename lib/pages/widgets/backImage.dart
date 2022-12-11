import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: 500,
      child: Image.asset('assets/images/persona-votando.jpeg',
          fit: BoxFit.none,
          color: const Color.fromARGB(255, 112, 110, 110).withOpacity(0.8),
          colorBlendMode: BlendMode.modulate),
    );
  }
}
