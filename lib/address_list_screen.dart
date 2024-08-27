import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class AddressListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<LatLng> markers = ModalRoute.of(context)?.settings.arguments as List<LatLng>; // recebe a lista de marcadores

    // lista de endereços padrão
    final List<Map<String, dynamic>> defaultAddresses = [
      {
        'title': 'FIAP',
        'latLng': LatLng(-23.574026, -46.623621),
      },
      {
        'title': 'Casa',
        'latLng': LatLng(-23.561684, -46.655981),
      },
      {
        'title': 'Trabalho',
        'latLng': LatLng(-23.588245, -46.683143),
      },
    ];

    // combina endereços padrão com os adicionados pelo usuári
    final List<Map<String, dynamic>> allAddresses = [
      ...defaultAddresses,
      ...markers.map((marker) => {
            'title': 'Endereço Adicionado',
            'latLng': marker,
          }),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Lista de Endereços')), // título 
      body: ListView.separated(
        itemCount: allAddresses.length, // total de endereços na lista
        itemBuilder: (context, index) {
          final address = allAddresses[index]; // pega o endereço da lista
          final LatLng latLng = address['latLng'];
          final String title = address['title'];

          return ListTile(
            leading: Icon(Icons.location_pin, color: Color(0xFFed145b), size: 30), // ícone do marcador
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFed145b)), // estilo do título
            ),
            subtitle: Text(
              'Latitude: ${latLng.latitude.toStringAsFixed(4)}, Longitude: ${latLng.longitude.toStringAsFixed(4)}',
              style: TextStyle(color: Color(0xFFed145b), fontWeight: FontWeight.bold), // estilo do subtítulo
            ),
            onTap: () {
              Navigator.pop(context, latLng); // retorna as coordenadas do endereço selecionado
            },
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16), // ícone da seta à direita
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey[300], // cor do divisor
            thickness: 1,
            indent: 16,
            endIndent: 16,
          );
        },
      ),
    );
  }
}
