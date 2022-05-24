import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:letstalk/core/services/LocationService.dart';
import 'package:letstalk/ui/widgets/CustomButton/CustomButton.dart';
import 'package:letstalk/utils/styles.dart';

class GeoLocation extends StatefulWidget {
  const GeoLocation({Key? key}) : super(key: key);

  @override
  State<GeoLocation> createState() => _GeoLocationState();
}

class _GeoLocationState extends State<GeoLocation> {
  Placemark? currentAddress;
  Position? position;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  height: 200,
                  child: Text('Locality : ${currentAddress ?? ""}')),
              CustomButton(
                onTapCallBack: () async {
                  Position pos = await determinePosition(context);
                  print(pos);
                  List marks = await convertCoordinatesToAddresses(
                      pos.longitude, pos.latitude);
                  // print(marks);
                  setState(() {
                    currentAddress = marks[3];
                  });
                  print(currentAddress);
                  // List places = await convertCoordinatesToPlaceMarks(
                  //     pos['longitude'], pos['latitude']);
                },
                title: "Click here to get your location",
              )
            ],
          ),
        ),
      ),
    );
  }
}
