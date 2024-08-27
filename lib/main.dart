import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'add_address_screen.dart';
import 'address_list_screen.dart';

// função main
void main() {
  runApp(MyApp());
}

// class myapp que inicia o app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FIAP - Atividade Cap 7 - Fase 5', // título do app
      theme: ThemeData(
        // cores principais
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFFed145b), // cor FIAP (para textos, botões, ícones)
          secondary: Color(0xFFed145b),
        ),
        scaffoldBackgroundColor: Colors.white, // fundo branco para as telas
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Color(0xFFed145b)),
          titleTextStyle: TextStyle(
            color: Color(0xFFed145b),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFed145b),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Color(0xFFed145b), fontWeight: FontWeight.bold), // estilo para títulos
          bodyMedium: TextStyle(color: Color(0xFFed145b), fontWeight: FontWeight.bold), 
          titleMedium: TextStyle(color: Color(0xFFed145b), fontWeight: FontWeight.bold), 
        ),
        dividerColor: Colors.grey[300],
      ),
      home: MapScreen(), // tela inicial como mapa
      routes: {
        '/add': (context) => AddAddressScreen(), // rota para a tela de adicionar endereço
        '/list': (context) => AddressListScreen(), // rota para a tela de listagem de endereços
      },
    );
  }
}
