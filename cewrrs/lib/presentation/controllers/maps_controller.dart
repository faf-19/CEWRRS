import 'package:cewrrs/presentation/pages/map/incident_location.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapsController extends GetxController {
  final RxList<IncidentLocation> locations = <IncidentLocation>[
    IncidentLocation(
      lat: 9.0108,
      lng: 38.7613,
      label: "Meskel Square",
      description: "Traditional mediation, community dialogue, government intervention.",
      incidentTime: "01:25 AM",
      status: "Resolved",
    ),
    IncidentLocation(
      lat: 9.0300,
      lng: 38.7400,
      label: "Bole Airport",
      description: "Security intervention due to protest.",
      incidentTime: "03:10 PM",
      status: "Active",
    ),
    IncidentLocation(
      lat: 9.0208,
      lng: 38.7623,
      label: "Fun Building",
      description: "Tmodern commercial center",
      incidentTime: "09:75 AM",
      status: "Resolved",
    ),
  ].obs;
  
}
