import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng _initialLocation = LatLng(-23.574026, -46.623621); // coord fiap
  LatLng _userLocation = LatLng(-23.574026, -46.623621); // posição inicial
  String _locationText = "Lat: -23.574026, Long: -46.623621"; 
  List<Marker> _markers = []; // lista de marcadores
  List<LatLng> _markerPositions = []; // lista de posições dos marcadores

  @override
  void initState() {
    super.initState();
    _determinePosition(); // pega a posição do usuário
    _initializeDefaultMarkers(); // inicializa marcadores padrão
  }

  void _initializeDefaultMarkers() {
    // adiciona marcadores padrões de escola, casa e trabalho
    setState(() {
      _addMarker(LatLng(-23.574026, -46.623621), Icons.location_pin); // fiap
      _addMarker(LatLng(-23.561684, -46.655981), Icons.home); // casa
      _addMarker(LatLng(-23.588245, -46.683143), Icons.work); // trabalho
    });
  }

  void _addMarker(LatLng position, IconData icon) {
    _markers.add(
      Marker(
        point: position,
        builder: (ctx) => Icon(icon, color: Color(0xFFed145b), size: 30), // cria o ícone
      ),
    );
    _markerPositions.add(position); // adiciona a posição na lista
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('serviços de localização estão desativados.')), // mostra msg se o serviço de localização estiver desativado
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('permissão de localização negada.')), // mostra msg se a permissão for negada
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('permissão de localização negada para sempre.')), // mostra msg se a permissão for negada permanentemente
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude); // atualiza a posição do usuário
      _locationText = "Lat: ${position.latitude}, Long: ${position.longitude}"; // atualiza o texto com a localização
      _mapController.move(_userLocation, 15.0); // move o mapa para a localização do usuário

      // adiciona mark para posição do usuario
      _addMarker(_userLocation, Icons.my_location); // adiciona um marcador na posição do usuário
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa com endereços favoritos!'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _initialLocation, // fiap
                zoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.fiap',
                ),
                MarkerLayer(
                  markers: _markers, // adiciona os marcadores no mapa
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _locationText, // mostra a localização
              style: TextStyle(fontSize: 16, color: Color(0xFFed145b), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final LatLng? newMarker = await Navigator.pushNamed(context, '/add') as LatLng?;
              if (newMarker != null) {
                setState(() {
                  _addMarker(newMarker, Icons.location_pin); // adiciona marcador
                  _mapController.move(newMarker, 15.0); // move o mapa para o novo marcador
                  _locationText = "Lat: ${newMarker.latitude}, Long: ${newMarker.longitude}"; // atualiza o texto com a nova localização
                });
              }
            },
            child: Icon(Icons.add, color: Colors.white),
            heroTag: null,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              final LatLng? selectedMarker = await Navigator.pushNamed(context, '/list', arguments: _markerPositions) as LatLng?;
              if (selectedMarker != null) {
                setState(() {
                  _mapController.move(selectedMarker, 15.0); // move o mapa para o marcador selecionado
                  _locationText = "Lat: ${selectedMarker.latitude}, Long: ${selectedMarker.longitude}"; // atualiza o texto com a localização selecionada
                });
              }
            },
            child: Icon(Icons.list, color: Colors.white),
            heroTag: null,
          ),
        ],
      ),
    );
  }
}
