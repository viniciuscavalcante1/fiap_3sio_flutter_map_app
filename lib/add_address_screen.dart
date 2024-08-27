import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _latitudeController = TextEditingController(); // controlador para capturar a latitude
  final TextEditingController _longitudeController = TextEditingController(); // lng
  final _formKey = GlobalKey<FormState>(); // chave para o formulário de validação

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Endereço')), // titulo
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // chave de validação do formulário
          child: Column(
            children: [
              TextFormField(
                controller: _latitudeController, // campo para inserir a lat
                decoration: InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) { // valida a lat inserida
                  if (value == null || double.tryParse(value) == null) {
                    return 'Por favor, insira uma latitude válida'; // mensagem de erro
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _longitudeController, // campo para inserir a lng
                decoration: InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) { // valida a lng inserida
                  if (value == null || double.tryParse(value) == null) {
                    return 'Por favor, insira uma longitude válida'; // mensagem de erro
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) { // verifica se os dados são válidos
                    double lat = double.parse(_latitudeController.text); // converte lat para double
                    double lng = double.parse(_longitudeController.text); // converte lng para double
                    Navigator.pop(context, LatLng(lat, lng)); // retorna a nova localização para a tela anterior
                  }
                },
                child: Text('Adicionar'), // texto do botão
              ),
            ],
          ),
        ),
      ),
    );
  }
}
