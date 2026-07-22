import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../state/celebration_state.dart';
import '../theme/app_colors.dart';


class CelebrationOverlay extends StatefulWidget {
  final CelebrationState celebration;
  final VoidCallback onContinue;

  const CelebrationOverlay({
    super.key,
    required this.celebration,
    required this.onContinue,
  });

  @override
  State<CelebrationOverlay> createState() =>
      _CelebrationOverlayState();
}

class _ConfettiParticle {
  final double angle;
  final double velocity;
  final double size;
  final double rotation;
  final Color color;

  const _ConfettiParticle({
    required this.angle,
    required this.velocity,
    required this.size,
    required this.rotation,
    required this.color,
  });
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final List<_ConfettiParticle> particles;

  const _ConfettiPainter({
    required this.progress,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(
      size.width / 2,
      size.height / 2 - 110,
    );

    for (final p in particles) {
      final distance =
          Curves.easeOut.transform(progress) *
          p.velocity *
          2.2;

      final dx =
          origin.dx +
          math.cos(p.angle) * distance;

      final dy =
          origin.dy +
          math.sin(p.angle) * distance +
          progress * progress * 1100;

      final paint = Paint()..color = p.color;

      canvas.save();

      canvas.translate(dx, dy);

      canvas.rotate(
        p.rotation + progress * 16,
      );

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: p.size,
          height: p.size * .45,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(
    _ConfettiPainter oldDelegate,
  ) {
    return true;
  }
}

class _CelebrationOverlayState
    extends State<CelebrationOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _trophyController;

  late final AnimationController _confettiController;
  late final List<_ConfettiParticle> _particles;

  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _trophyScale;
  late final Animation<double> _glowScale;
  late final Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _trophyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
    );

    final random = math.Random();

    _particles = List.generate(
      60,
      (_) => _ConfettiParticle(
        angle: random.nextDouble() * math.pi * 2,
        velocity: 120 + random.nextDouble() * 180,
        size: 5 + random.nextDouble() * 7,
        rotation: random.nextDouble() * math.pi,
        color: [
          Colors.green,
          Colors.blue,
          Colors.orange,
          Colors.amber,
          Colors.purple,
          Colors.red,
        ][random.nextInt(6)],
      ),
    );

    _fade = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );

    _scale = Tween<double>(
      begin: .80,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.elasticOut,
      ),
    );

    _trophyScale = Tween<double>(
      begin: 1,
      end: 1.08,
    ).animate(
      CurvedAnimation(
        parent: _trophyController,
        curve: Curves.easeInOut,
      ),
    );

    _glowScale = Tween<double>(
      begin: .4,
      end: 1.8,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutCubic,
      ),
    );

    _glowOpacity = Tween<double>(
      begin: .8,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOut,
      ),
    );

    _entryController.forward();

    _confettiController.forward();

    _trophyController.repeat(
      reverse: true,
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    _trophyController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.celebration.isPending) {
      return const SizedBox.shrink();
    }

    final bool isLevel =
        widget.celebration.type ==
            CelebrationType.levelUp;

    final String headline =
        isLevel
            ? 'LEVEL ${widget.celebration.level ?? ''}'
            : '${widget.celebration.streakDays ?? ''} DAY STREAK';

    return FadeTransition(
      opacity: _fade,
      child: Container(
        color: Colors.black.withOpacity(.72),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _confettiController,
            builder: (_, __) {
              return IgnorePointer(
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _ConfettiPainter(
                    progress: _confettiController.value,
                    particles: _particles,
                  ),
                ),
              );
            },
          ),

          Center(
          child: ScaleTransition(
            scale: _scale,
            child: Container(
              width: 320,
              margin:
                  const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              padding:
                  const EdgeInsets.fromLTRB(
                24,
                22,
                24,
                20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 30,
                    color: Colors.black26,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [

                        FadeTransition(
                          opacity: _glowOpacity,
                          child: ScaleTransition(
                            scale: _glowScale,
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFFF3B0),
                              ),
                            ),
                          ),
                        ),

                        ScaleTransition(
                          scale: _trophyScale,
                          child: const Icon(
                            Icons.emoji_events_rounded,
                            color: Colors.amber,
                            size: 58,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    headline,
                    textAlign:
                        TextAlign.center,
                    style:
                        const TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.w900,
                      color:
                          AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    widget.celebration.title,
                    textAlign:
                        TextAlign.center,
                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    widget
                        .celebration.message,
                    textAlign:
                        TextAlign.center,
                    style:
                        const TextStyle(
                      fontSize: 15,
                      height: 1.35,
                      color:
                          Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                          widget.onContinue,
                      style:
                          ElevatedButton.styleFrom(
                        shape:
                            const StadiumBorder(),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);
  }
}