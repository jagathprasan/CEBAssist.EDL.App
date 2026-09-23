import 'package:latlong2/latlong.dart';

import '../widgets/maps/app_map.dart';

/// Demo outage points laid out like the EDLCare outage map.
class EdlNetworkSites {
  EdlNetworkSites._();

  static const LatLng colombo = LatLng(6.9271, 79.8612);
  static const LatLng island = LatLng(7.55, 80.65);

  static const String outageSummary =
      '199 breakdowns, 13 planned, 10935 customers affected';

  static const List<AppMapMarker> all = [
    AppMapMarker(
      id: 'loc-negombo',
      title: 'Your location',
      subtitle: 'Negombo',
      point: LatLng(7.21, 79.84),
      kind: AppMapPinKind.location,
    ),
    AppMapMarker(
      id: 'loc-colombo',
      title: 'Your location',
      subtitle: 'Colombo',
      point: LatLng(6.93, 79.86),
      kind: AppMapPinKind.location,
    ),
    AppMapMarker(
      id: 'loc-kandy',
      title: 'Your location',
      subtitle: 'Kandy',
      point: LatLng(7.29, 80.64),
      kind: AppMapPinKind.location,
    ),
    AppMapMarker(
      id: 'loc-nuwara',
      title: 'Your location',
      subtitle: 'Nuwara Eliya',
      point: LatLng(6.97, 80.78),
      kind: AppMapPinKind.location,
    ),
    AppMapMarker(
      id: 'loc-badulla',
      title: 'Your location',
      subtitle: 'Badulla',
      point: LatLng(6.99, 81.05),
      kind: AppMapPinKind.location,
    ),
    AppMapMarker(
      id: 'plan-south',
      title: 'Planned outage',
      subtitle: 'Southern feeder',
      point: LatLng(6.15, 80.35),
      kind: AppMapPinKind.planned,
    ),
    AppMapMarker(
      id: 'plan-west',
      title: 'Planned outage',
      subtitle: 'Western feeder',
      point: LatLng(6.72, 79.98),
      kind: AppMapPinKind.planned,
    ),
    AppMapMarker(
      id: 'plan-central',
      title: 'Planned outage',
      subtitle: 'Central feeder',
      point: LatLng(7.48, 80.62),
      kind: AppMapPinKind.planned,
    ),
    ..._breakdowns,
  ];

  static const List<AppMapMarker> _breakdowns = [
    AppMapMarker(
      id: 'bd-1',
      title: 'Breakdown',
      point: LatLng(7.36, 80.52),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-2',
      title: 'Breakdown',
      point: LatLng(7.33, 80.58),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-3',
      title: 'Breakdown',
      point: LatLng(7.30, 80.55),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-4',
      title: 'Breakdown',
      point: LatLng(7.28, 80.61),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-5',
      title: 'Breakdown',
      point: LatLng(7.34, 80.66),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-6',
      title: 'Breakdown',
      point: LatLng(7.26, 80.70),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-7',
      title: 'Breakdown',
      point: LatLng(7.22, 80.64),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-8',
      title: 'Breakdown',
      point: LatLng(7.18, 80.58),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-9',
      title: 'Breakdown',
      point: LatLng(7.40, 80.48),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-10',
      title: 'Breakdown',
      point: LatLng(7.12, 80.72),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-11',
      title: 'Breakdown',
      point: LatLng(7.05, 81.02),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-12',
      title: 'Breakdown',
      point: LatLng(7.02, 81.08),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-13',
      title: 'Breakdown',
      point: LatLng(6.96, 81.12),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-14',
      title: 'Breakdown',
      point: LatLng(6.92, 81.04),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-15',
      title: 'Breakdown',
      point: LatLng(6.88, 81.16),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-16',
      title: 'Breakdown',
      point: LatLng(7.08, 80.95),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-17',
      title: 'Breakdown',
      point: LatLng(6.84, 81.22),
      kind: AppMapPinKind.breakdown,
    ),
    AppMapMarker(
      id: 'bd-18',
      title: 'Breakdown',
      point: LatLng(7.46, 80.36),
      kind: AppMapPinKind.breakdown,
    ),
  ];

  static List<AppMapMarker> get field => all;
}
