import 'package:latlong2/latlong.dart';

import '../widgets/maps/app_map.dart';

/// Demo EDL network sites around Colombo for maps and dashboards.
class EdlNetworkSites {
  EdlNetworkSites._();

  static const LatLng colombo = LatLng(6.9271, 79.8612);

  static const List<AppMapMarker> all = [
    AppMapMarker(
      id: 'hq',
      title: 'Area office',
      subtitle: 'Dispatch desk',
      point: LatLng(6.9271, 79.8612),
      tone: AppMapMarkerTone.info,
    ),
    AppMapMarker(
      id: 'unit-a',
      title: 'Feeder inspection',
      subtitle: 'Unit A · Crew 3',
      point: LatLng(6.9384, 79.8542),
      tone: AppMapMarkerTone.success,
    ),
    AppMapMarker(
      id: 'unit-b',
      title: 'Outage coordination',
      subtitle: 'Unit B · delayed access',
      point: LatLng(6.9108, 79.8786),
      tone: AppMapMarkerTone.warning,
    ),
    AppMapMarker(
      id: 'unit-c',
      title: 'Meter replacement',
      subtitle: 'Unit C · store issued',
      point: LatLng(6.9512, 79.8721),
      tone: AppMapMarkerTone.primary,
    ),
    AppMapMarker(
      id: 'feeder-11',
      title: 'Feeder 11',
      subtitle: 'Pole 24 · current job',
      point: LatLng(6.9210, 79.8475),
      tone: AppMapMarkerTone.error,
    ),
  ];

  static List<AppMapMarker> get field =>
      all.where((site) => site.id != 'hq').toList();
}
