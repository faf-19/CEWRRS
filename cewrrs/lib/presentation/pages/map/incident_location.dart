

class IncidentLocation {
  final double lat;
  final double lng;
  final String label;
  final String description;
  final String incidentTime;
  final String status;

  IncidentLocation({
    required this.lat,
    required this.lng,
    required this.label,
    required this.description,
    required this.incidentTime,
    required this.status,
  });
}
