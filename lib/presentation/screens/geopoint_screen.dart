import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:peppers_admin_panel/data/models/delivery_point.dart';
import 'package:peppers_admin_panel/presentation/components/custom_elevated_button.dart';
import 'package:peppers_admin_panel/presentation/config/constants.dart';

class GeopointScreen extends StatefulWidget {
  const GeopointScreen({super.key, this.deliveryPoint});

  final DeliveryPoint? deliveryPoint;

  @override
  State<GeopointScreen> createState() => _GeopointScreenState();
}

class _GeopointScreenState extends State<GeopointScreen> {
  late List<Marker> markers;

  @override
  void initState() {
    markers = widget.deliveryPoint != null
        ? [
            Marker(
              markerId: MarkerId(widget.deliveryPoint!.address),
              position: widget.deliveryPoint!.latLng,
              infoWindow: InfoWindow(
                  title: widget.deliveryPoint!.address,
                  snippet: "Точка самовывоза Pikapika"),
            )
          ]
        : [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Constants.primaryColor,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                  target: LatLng(43.2398052, 76.8906515), zoom: 12),
              markers: Set.from(markers),
              onTap: (point) {
                if (widget.deliveryPoint == null) {
                  setState(() {
                    markers = [
                      Marker(
                        draggable: true,
                        markerId: const MarkerId("id"),
                        position: point,
                        infoWindow: const InfoWindow(
                            title: "Точка самовывоза Pikapika",
                            snippet:
                                "Если точка указана верно, то подтвердите свой выбор"),
                      )
                    ];
                  });
                }
              },
            ),
          ),
          markers.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.all(Constants.defaultPadding * 1.5),
                  child: CustomElevatedButton(
                      text: "Подтвердить",
                      width: 150,
                      height: 43,
                      fontSize: Constants.textTheme.bodyLarge!.fontSize,
                      function: () {
                        Navigator.pop(context, markers.first.position);
                      }),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
    ;
  }
}
