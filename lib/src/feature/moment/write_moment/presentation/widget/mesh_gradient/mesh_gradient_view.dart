import 'dart:math';

import 'package:diary_mobile_client/main.dart';
import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

import '../../../../../common/moment/domain/entity/moment.dart';

class MeshGradientView extends StatefulWidget {
  const MeshGradientView({super.key, required this.moment});
  final Moment moment;

  @override
  State<MeshGradientView> createState() => _MeshGradientViewState();
}

class _MeshGradientViewState extends State<MeshGradientView>
    with TickerProviderStateMixin {
  late MeshGradientController _controller;

  @override
  void initState() {
    _controller = MeshGradientController(
      points: [
        if (widget.moment.emotionalIntensities.isNotEmpty)
          MeshGradientPoint(
              position: Offset(
                0.1 + (0.8 * (Random().nextDouble())),
                0.1 + (0.8 * (Random().nextDouble())),
              ),
              color: widget.moment.emotionalIntensities.first.emotion.color
              // .withOpacity(0.5 +
              //     (widget.moment.emotionalIntensities.first.intensity * 0.5)),
              ),
        if (widget.moment.emotionalIntensities.length > 1)
          MeshGradientPoint(
              position: Offset(
                0.1 + (0.8 * (Random().nextDouble())),
                0.1 + (0.8 * (Random().nextDouble())),
              ),
              color: widget.moment.emotionalIntensities[1].emotion.color
              // .withOpacity(0.5 +
              //     (widget.moment.emotionalIntensities[1].intensity * 0.5)),
              ),
        if (widget.moment.emotionalIntensities.length > 2)
          MeshGradientPoint(
              position: Offset(
                0.1 + (0.8 * (Random().nextDouble())),
                0.1 + (0.8 * (Random().nextDouble())),
              ),
              color: widget.moment.emotionalIntensities[2].emotion.color
              // .withOpacity(0.5 +
              //     (widget.moment.emotionalIntensities[2].intensity * 0.5)),
              ),
        if (widget.moment.emotionalIntensities.length > 3)
          MeshGradientPoint(
              position: Offset(
                0.1 + (0.8 * (Random().nextDouble())),
                0.1 + (0.8 * (Random().nextDouble())),
              ),
              color: widget.moment.emotionalIntensities[3].emotion.color
              // .withOpacity(0.5 +
              //     (widget.moment.emotionalIntensities[3].intensity * 0.5)),
              ),
      ],
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    try {
      _controller.dispose();
    } catch (e) {
      logger.e(e);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MeshGradient(
      controller: _controller,
      options: MeshGradientOptions(
        blend: 3.5,
        noiseIntensity: 0.2,
      ),
    );
  }
}
