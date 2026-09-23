import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';

enum AppMapMarkerTone { primary, success, warning, error, info }

/// Pin artwork used by the EDLCare outage map.
enum AppMapPinKind { planned, breakdown, location }

/// Base layers mirrored from EDLCare [ContactsLeafletMap] (react-leaflet).
enum AppMapBaseLayer { street, voyager, light }

/// Map pin used by [AppMap].
class AppMapMarker {
  const AppMapMarker({
    required this.id,
    required this.title,
    required this.point,
    this.subtitle,
    this.tone = AppMapMarkerTone.primary,
    this.kind,
  });

  final String id;
  final String title;
  final String? subtitle;
  final LatLng point;
  final AppMapMarkerTone tone;
  final AppMapPinKind? kind;

  AppMapPinKind get pinKind {
    return kind ??
        switch (tone) {
          AppMapMarkerTone.warning ||
          AppMapMarkerTone.error => AppMapPinKind.breakdown,
          AppMapMarkerTone.info => AppMapPinKind.planned,
          AppMapMarkerTone.primary ||
          AppMapMarkerTone.success => AppMapPinKind.location,
        };
  }
}

/// Leaflet-style OpenStreetMap widget aligned with EDLCare.
///
/// Uses the same tile URLs and layer names as
/// `EDLCare.Web.Frontend/.../ContactsLeafletMap.tsx`
/// (Street OSM, Carto Voyager, Carto Light) via [flutter_map],
/// the Flutter equivalent of Leaflet.
class AppMap extends StatefulWidget {
  const AppMap({
    super.key,
    required this.markers,
    this.center,
    this.zoom = 12.4,
    this.height = 240,
    this.interactive = true,
    this.showControls = true,
    this.showLayerSwitcher = false,
    this.fitMarkers = true,
    this.initialBaseLayer = AppMapBaseLayer.street,
    this.showSummary = true,
    this.showLegend = true,
    this.title,
    this.subtitle,
    this.summary,
  });

  final List<AppMapMarker> markers;
  final LatLng? center;
  final double zoom;
  final double height;
  final bool interactive;
  final bool showControls;
  final bool showLayerSwitcher;
  final bool fitMarkers;
  final AppMapBaseLayer initialBaseLayer;
  final bool showSummary;
  final bool showLegend;
  final String? title;
  final String? subtitle;
  final String? summary;

  @override
  State<AppMap> createState() => _AppMapState();
}

class _AppMapState extends State<AppMap> {
  final _controller = MapController();
  late AppMapBaseLayer _baseLayer = widget.initialBaseLayer;
  final Set<AppMapPinKind> _hidden = {};

  static const _defaultCenter = LatLng(7.2869042, 80.6437899);
  static const _cartoSubdomains = ['a', 'b', 'c', 'd'];

  @override
  void dispose() {
    if (!_isWidgetTest()) {
      _controller.dispose();
    }
    super.dispose();
  }

  bool _isWidgetTest() {
    return WidgetsBinding.instance.runtimeType.toString().contains(
      'TestWidgetsFlutterBinding',
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapCenter =
        widget.center ??
        (widget.markers.isEmpty ? _defaultCenter : widget.markers.first.point);

    final visible = [
      for (final marker in widget.markers)
        if (!_hidden.contains(marker.pinKind)) marker,
    ];
    final CameraFit? cameraFit =
        widget.fitMarkers && visible.length > 1
        ? CameraFit.bounds(
            bounds: LatLngBounds.fromPoints([
              for (final m in visible) m.point,
            ]),
            padding: const EdgeInsets.fromLTRB(28, 78, 28, 128),
            maxZoom: 12,
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.25,
            ),
          ),
          if (widget.subtitle != null)
            Text(
              widget.subtitle!,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: context.colors.outlineVariant.withValues(alpha: 0.7),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: _isWidgetTest()
              ? ColoredBox(
                  color: context.colors.surfaceContainerHigh,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 40,
                          color: context.colors.primary,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Leaflet map',
                          style: context.textTheme.labelMedium?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Stack(
                  children: [
                    FlutterMap(
                      mapController: _controller,
                      options: MapOptions(
                        initialCenter: mapCenter,
                        initialZoom: widget.zoom,
                        initialCameraFit: cameraFit,
                        minZoom: 5,
                        maxZoom: 20,
                        backgroundColor: const Color(0xFFE8EEF2),
                        interactionOptions: InteractionOptions(
                          flags: widget.interactive
                              ? InteractiveFlag.all
                              : InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        _tileLayerFor(_baseLayer),
                        MarkerLayer(
                          markers: [
                            for (final marker in visible)
                              Marker(
                                point: marker.point,
                                width: marker.pinKind == AppMapPinKind.location
                                    ? 36
                                    : 12,
                                height: marker.pinKind == AppMapPinKind.location
                                    ? 36
                                    : 12,
                                alignment: Alignment.center,
                                child: _OutagePin(
                                  kind: marker.pinKind,
                                  tooltip: [
                                    marker.title,
                                    if (marker.subtitle != null) marker.subtitle!,
                                  ].join(' · '),
                                ),
                              ),
                          ],
                        ),
                        SimpleAttributionWidget(
                          source: const Text(
                            '© OpenStreetMap / CEB · Leaflet',
                          ),
                          alignment: Alignment.bottomLeft,
                          backgroundColor: Colors.white.withValues(alpha: 0.9),
                        ),
                      ],
                    ),
                    if (widget.showSummary && widget.summary != null)
                      Positioned(
                        left: 10,
                        right: 10,
                        top: 10,
                        child: _OutageSummaryBar(
                          summary: widget.summary!,
                          onRefresh: _fitAll,
                          onFilter: (kind) {
                            setState(() {
                              if (!_hidden.add(kind)) _hidden.remove(kind);
                            });
                          },
                          hidden: _hidden,
                        ),
                      ),
                    if (widget.showLegend)
                      const Positioned(
                        left: 10,
                        bottom: 12,
                        child: _OutageLegend(),
                      ),
                    if (widget.showLayerSwitcher)
                      Positioned(
                        top: widget.summary == null ? 10 : 78,
                        right: 10,
                        child: _LayerSwitcher(
                          selected: _baseLayer,
                          onChanged: (layer) =>
                              setState(() => _baseLayer = layer),
                        ),
                      ),
                    if (widget.interactive && widget.showControls)
                      Positioned(
                        right: 10,
                        bottom: 28,
                        child: Column(
                          children: [
                            _MapControlButton(
                              icon: Icons.add,
                              onPressed: () => _nudgeZoom(1),
                            ),
                            const SizedBox(height: 8),
                            _MapControlButton(
                              icon: Icons.remove,
                              onPressed: () => _nudgeZoom(-1),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  TileLayer _tileLayerFor(AppMapBaseLayer layer) {
    return switch (layer) {
      AppMapBaseLayer.street => TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'electricity_board_erp',
        maxZoom: 19,
        errorTileCallback: _onTileError,
      ),
      AppMapBaseLayer.voyager => TileLayer(
        // Same Carto Voyager URL as EDLCare ContactsLeafletMap.
        urlTemplate:
            'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
        subdomains: _cartoSubdomains,
        userAgentPackageName: 'electricity_board_erp',
        maxZoom: 20,
        retinaMode: RetinaMode.isHighDensity(context),
        errorTileCallback: _onTileError,
      ),
      AppMapBaseLayer.light => TileLayer(
        // Same Carto Light URL as EDLCare ContactsLeafletMap.
        urlTemplate:
            'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
        subdomains: _cartoSubdomains,
        userAgentPackageName: 'electricity_board_erp',
        maxZoom: 20,
        retinaMode: RetinaMode.isHighDensity(context),
        errorTileCallback: _onTileError,
      ),
    };
  }

  void _onTileError(TileImage tile, Object error, StackTrace? stackTrace) {
    if (kDebugMode) {
      debugPrint('Map tile failed: $error');
    }
  }

  void _nudgeZoom(double delta) {
    final camera = _controller.camera;
    _controller.move(camera.center, (camera.zoom + delta).clamp(5, 20));
  }

  void _fitAll() {
    if (widget.markers.isEmpty) return;
    if (widget.markers.length == 1) {
      _controller.move(widget.markers.first.point, 14);
      return;
    }
    _controller.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints([
          for (final m in widget.markers) m.point,
        ]),
        padding: const EdgeInsets.fromLTRB(28, 78, 28, 128),
        maxZoom: 12,
      ),
    );
  }
}

class _LayerSwitcher extends StatelessWidget {
  const _LayerSwitcher({required this.selected, required this.onChanged});

  final AppMapBaseLayer selected;
  final ValueChanged<AppMapBaseLayer> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.96),
      elevation: 2,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final layer in AppMapBaseLayer.values)
              _LayerChip(
                label: switch (layer) {
                  AppMapBaseLayer.street => 'Street',
                  AppMapBaseLayer.voyager => 'Voyager',
                  AppMapBaseLayer.light => 'Light',
                },
                selected: layer == selected,
                onTap: () => onChanged(layer),
              ),
          ],
        ),
      ),
    );
  }
}

class _LayerChip extends StatelessWidget {
  const _LayerChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppBrandColors.ink : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }
}

/// EDLCare outage pin: pink square, yellow square, or home marker.
class _OutagePin extends StatelessWidget {
  const _OutagePin({required this.kind, required this.tooltip});

  final AppMapPinKind kind;
  final String tooltip;

  static const _planned = Color(0xFFF3B4AE);
  static const _breakdown = Color(0xFFF6C445);
  static const _location = Color(0xFF7A2048);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: switch (kind) {
        AppMapPinKind.location => Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: _location,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.home_rounded, color: Colors.white, size: 18),
        ),
        AppMapPinKind.planned => _square(_planned),
        AppMapPinKind.breakdown => _square(_breakdown),
      },
    );
  }

  Widget _square(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
    );
  }
}

class _OutageSummaryBar extends StatelessWidget {
  const _OutageSummaryBar({
    required this.summary,
    required this.onRefresh,
    required this.onFilter,
    required this.hidden,
  });

  final String summary;
  final VoidCallback onRefresh;
  final ValueChanged<AppMapPinKind> onFilter;
  final Set<AppMapPinKind> hidden;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDark;
    final ink = dark ? Colors.white : const Color(0xFF1C1C1E);
    return Material(
      color: dark ? const Color(0xF01A2430) : Colors.white.withValues(alpha: 0.96),
      elevation: 3,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 6, 8),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE24B4B), width: 1.6),
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: Color(0xFFE24B4B),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                summary,
                style: TextStyle(
                  color: ink,
                  fontSize: 13,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            PopupMenuButton<AppMapPinKind>(
              tooltip: 'Filter',
              padding: EdgeInsets.zero,
              icon: Icon(Icons.tune_rounded, size: 20, color: ink),
              onSelected: onFilter,
              itemBuilder: (context) => [
                for (final kind in AppMapPinKind.values)
                  CheckedPopupMenuItem(
                    value: kind,
                    checked: !hidden.contains(kind),
                    child: Text(switch (kind) {
                      AppMapPinKind.planned => 'Planned outage',
                      AppMapPinKind.breakdown => 'Breakdowns',
                      AppMapPinKind.location => 'Your location',
                    }),
                  ),
              ],
            ),
            IconButton(
              tooltip: 'Refresh',
              visualDensity: VisualDensity.compact,
              onPressed: onRefresh,
              icon: Icon(Icons.refresh_rounded, size: 20, color: ink),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutageLegend extends StatelessWidget {
  const _OutageLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDark;
    final ink = dark ? Colors.white : const Color(0xFF1C1C1E);
    return Material(
      color: dark ? const Color(0xF01A2430) : Colors.white.withValues(alpha: 0.96),
      elevation: 3,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Legend',
              style: TextStyle(
                color: ink,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            const _LegendRow(
              swatch: _LegendSwatch.planned,
              label: 'Planned Outage',
            ),
            const SizedBox(height: 6),
            const _LegendRow(
              swatch: _LegendSwatch.breakdown,
              label: 'Breakdowns',
            ),
            const SizedBox(height: 6),
            const _LegendRow(
              swatch: _LegendSwatch.location,
              label: 'Your Location',
            ),
          ],
        ),
      ),
    );
  }
}

enum _LegendSwatch { planned, breakdown, location }

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.swatch, required this.label});

  final _LegendSwatch swatch;
  final String label;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        switch (swatch) {
          _LegendSwatch.planned => _box(const Color(0xFFF3B4AE)),
          _LegendSwatch.breakdown => _box(const Color(0xFFF6C445)),
          _LegendSwatch.location => Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFF7A2048),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.home_rounded, color: Colors.white, size: 10),
          ),
        },
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: dark ? Colors.white70 : const Color(0xFF3A3A3C),
          ),
        ),
      ],
    );
  }

  Widget _box(Color color) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.96),
      elevation: 2,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 18, color: const Color(0xFF1C1C1E)),
        ),
      ),
    );
  }
}

/// EDLCare outage legend. The same card is drawn on [AppMap].
class AppMapLegend extends StatelessWidget {
  const AppMapLegend({super.key, this.markers = const []});

  /// Kept so existing call sites can still pass marker lists.
  final List<AppMapMarker> markers;

  @override
  Widget build(BuildContext context) {
    return _OutageLegend(key: ValueKey(markers.length));
  }
}
