import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(52.43775156440748, 31.003112813409757);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Only Kids Gomel',
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Ulitsa Rogachovskaya 2a, Homieĺ 246000'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.phone),
                title: Text('+375 29 137-20-65'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/instagram.svg',
                  height: 30.0,
                ),
                title: Text('Instagram'),
              ),
            ),
            Container(
              height: 300.0,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 13.0,
                ),
                markers: Set.from([
                  Marker(
                    markerId: MarkerId('onlyKids'),
                    position: _center,
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
