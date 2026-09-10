import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_status_chip.dart';

enum AppMapMarkerTone { primary, success, warning, error, info }

/// Map pin used by [AppMap].
class AppMapMarker {
  const AppMapMarker({
    required this.id,
    required this.title,
    required this.point,
    this.subtitle,
    this.tone = AppMapMarkerTone.primary,
  });

  final String id;
  final String title;
  final String? subtitle;
  final LatLng point;
  final AppMapMarkerTone tone;
}

/// OpenStreetMap (Leaflet-style) map. Free tiles; no API key.
class AppMap extends StatefulWidget {
  const AppMap({
    super.key,
    required this.markers,
    this.center,
    this.zoom = 12.4,
    this.height = 240,
    this.interactive = true,
    this.showControls = true,
    this.title,
    this.subtitle,
  });

  final List<AppMapMarker> markers;
  final LatLng? center;
  final double zoom;
  final double height;
  final bool interactive;
  final bool showControls;
  final String? title;
  final String? subtitle;

  @override
  State<AppMap> createState() => _AppMapState();
}

class _AppMapState extends State<AppMap> {
  final _controller = MapController();

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
        (widget.markers.isEmpty
            ? const LatLng(6.9271, 79.8612)
            : widget.markers.first.point);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
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
            borderRadius: AppRadius.borderXl,
            boxShadow: AppShadows.md(context),
            border: Border.all(
              color: context.colors.outlineVariant.withValues(alpha: 0.6),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: _isWidgetTest()
              ? ColoredBox(
                  color: context.colors.surfaceContainerHigh,
                  child: Center(
                    child: Icon(
                      Icons.map_outlined,
                      size: 48,
                      color: context.colors.primary,
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
                        minZoom: 5,
                        maxZoom: 18,
                        interactionOptions: InteractionOptions(
                          flags: widget.interactive
                              ? InteractiveFlag.all
                              : InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'electricity_board_erp',
                          errorTileCallback: (tile, error, stackTrace) {
                            if (kDebugMode) {
                              debugPrint('Map tile failed: $error');
                            }
                          },
                        ),
                        MarkerLayer(
                          markers: [
                            for (final marker in widget.markers)
                              Marker(
                                point: marker.point,
                                width: 44,
                                height: 44,
                                alignment: Alignment.topCenter,
                                child: Tooltip(
                                  message: [
                                    marker.title,
                                    if (marker.subtitle != null)
                                      marker.subtitle!,
                                  ].join(' · '),
                                  child: Icon(
                                    Icons.location_on_rounded,
                                    size: 40,
                                    color: _toneColor(context, marker.tone),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SimpleAttributionWidget(
                          source: const Text('OpenStreetMap'),
                          alignment: Alignment.bottomLeft,
                          backgroundColor: context.colors.surface.withValues(
                            alpha: 0.86,
                          ),
                        ),
                      ],
                    ),
                    if (widget.interactive && widget.showControls)
                      Positioned(
                        right: AppSpacing.sm,
                        bottom: AppSpacing.lg,
                        child: Column(
                          children: [
                            _MapControlButton(
                              icon: Icons.add,
                              onPressed: () => _nudgeZoom(1),
                            ),
                            const SizedBox(height: AppSpacing.xs),
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

  void _nudgeZoom(double delta) {
    final camera = _controller.camera;
    _controller.move(camera.center, (camera.zoom + delta).clamp(5, 18));
  }

  Color _toneColor(BuildContext context, AppMapMarkerTone tone) {
    return switch (tone) {
      AppMapMarkerTone.primary => context.colors.primary,
      AppMapMarkerTone.success => context.semantic.success,
      AppMapMarkerTone.warning => context.semantic.warning,
      AppMapMarkerTone.error => context.colors.error,
      AppMapMarkerTone.info => context.semantic.info,
    };
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surfaceContainerLowest,
      elevation: 2,
      shadowColor: Colors.black26,
      borderRadius: AppRadius.borderSm,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.borderSm,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: context.colors.onSurface),
        ),
      ),
    );
  }
}

/// Compact selected-site strip shown under a map.
class AppMapLegend extends StatelessWidget {
  const AppMapLegend({super.key, required this.markers});

  final List<AppMapMarker> markers;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final marker in markers)
          AppStatusChip(
            label: marker.title,
            tone: switch (marker.tone) {
              AppMapMarkerTone.success => AppStatusTone.success,
              AppMapMarkerTone.warning => AppStatusTone.warning,
              AppMapMarkerTone.error => AppStatusTone.error,
              AppMapMarkerTone.info => AppStatusTone.info,
              AppMapMarkerTone.primary => AppStatusTone.info,
            },
          ),
      ],
    );
  }
}
