import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kada_ngalih/core/util/map_style.dart';
import 'package:kada_ngalih/features/nearby_location/presentation/bloc/bloc.dart';
import 'package:kada_ngalih/features/nearby_location/presentation/widgets/custom_list_item.dart';
import 'package:kada_ngalih/features/nearby_location/presentation/widgets/custom_loading_indicator.dart';
import 'package:kada_ngalih/injection_container.dart';
import 'package:transparent_image/transparent_image.dart';

const distance = "2";

class NearbyLocationPage extends StatefulWidget {
  @override
  _NearbyLocationPageState createState() => _NearbyLocationPageState();
}

class _NearbyLocationPageState extends State<NearbyLocationPage>
    with AutomaticKeepAliveClientMixin {
  Completer<GoogleMapController> _completer = Completer();
  Completer<void> _refreshCompleter;
  final _nearbyLocationBloc = sl<NearbyLocationBloc>();
  double lat;
  double lng;
  Set<Marker> _markers = Set();
  List<Placemark> _placemark = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((k) {
      lat = k.latitude == 0 ? -3.316694 : k.latitude;
      lng = k.longitude == 0 ? 114.590111 : k.longitude;

      Geolocator()
          .placemarkFromCoordinates(k.latitude, k.longitude)
          .then((place) {
        _placemark.addAll(place);
      });

      setState(() {
        _nearbyLocationBloc.add(GetNearbyLocationEvent(
            distance: distance, lat: lat.toString(), lng: lng.toString()));
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _nearbyLocationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Color(0XFFF1F2F6),
      body: lat == null || lng == null
          ? CustomLoadingIndiCator(
              message: "Mendapatkan Lokasi",
            )
          : SafeArea(
              top: false,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.5,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(lat, lng),
                          zoom: 14,
                        ),
                        myLocationEnabled: true,
                        onMapCreated: _onMapCreated,
                        markers: _markers,
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.35,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color(0XFFF1F2F6),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: _buildBody(context),
                      ),
                    ),
                  ),
                  _placemark.isEmpty
                      ? Positioned(
                          top: 50,
                          left: 30,
                          child: Container(
                              child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              Color(0XFF496EFA),
                            ),
                          )),
                        )
                      : Positioned(
                          top: MediaQuery.of(context).size.height * 0.3,
                          left: 16,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${_placemark[0].name}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                                softWrap: true,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  BlocProvider<NearbyLocationBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => _nearbyLocationBloc,
      child: BlocBuilder<NearbyLocationBloc, NearbyLocationState>(
        bloc: _nearbyLocationBloc,
        builder: (context, NearbyLocationState state) {
          if (state is LoadingState) {
            return CustomLoadingIndiCator(
              message: "Memuat data",
            );
          } else if (state is LoadedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              for (var i in state.nearbyLocation.data) {
                setState(() {
                  _markers.add(
                    Marker(
                      markerId: MarkerId(i.id.toString()),
                      position: LatLng(i.lat, i.lng),
                      infoWindow: InfoWindow(
                        title: i.name,
                        snippet: i.address,
                      ),
                      icon: BitmapDescriptor.defaultMarker,
                    ),
                  );
                });
              }
            });
            return RefreshIndicator(
              onRefresh: _refreshLocation,
              child: ListView.builder(
                padding: EdgeInsets.only(
                  top: 11,
                  bottom: 60,
                ),
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: state.nearbyLocation.data.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: (() {
                      _goToMarker(
                        state.nearbyLocation.data[i].lat,
                        state.nearbyLocation.data[i].lng,
                      );
                    }),
                    child: CustomListItem(
                      thumbnail: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: state.nearbyLocation.data[i].image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: state.nearbyLocation.data[i].name,
                      address: state.nearbyLocation.data[i].address,
                      distance:
                          state.nearbyLocation.data[i].distance.toString(),
                      category:
                          state.nearbyLocation.data[i].category.name.toString(),
                      source: state.nearbyLocation.data[i].source,
                    ),
                  );
                },
              ),
            );
          } else if (state is ErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  state.errorMessage,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Future<void> _goToMarker(double lat, double lng) async {
    final GoogleMapController controller = await _completer.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 16,
          bearing: 45,
          tilt: 50,
        ),
      ),
    );
  }

  Future<void> _toCenter(double lat, double lng) async {
    final GoogleMapController controller = await _completer.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 14,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(MapStyle.style);
    _completer.complete(controller);
  }

  Future _refreshLocation() async {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((k) {
      lat = k.latitude == 0 ? -3.316694 : k.latitude;
      lng = k.longitude == 0 ? 114.590111 : k.longitude;
      _nearbyLocationBloc.add(RefreshNearbyLocation(
          distance: distance, lat: lat.toString(), lng: lng.toString()));
      _toCenter(lat, lng);
      setState(() {
        _placemark.clear();
        _markers.clear();
        Geolocator()
            .placemarkFromCoordinates(k.latitude, k.longitude)
            .then((place) {
          _placemark.addAll(place);
        });
      });
    });
    return _refreshCompleter.future;
  }
}
