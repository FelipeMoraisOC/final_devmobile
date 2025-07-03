import 'package:flutter/material.dart';

class AnimatedProgressCircle extends StatefulWidget {
  final double progress; // de 0.0 a 1.0

  const AnimatedProgressCircle({Key? key, required this.progress})
    : super(key: key);

  @override
  State<AnimatedProgressCircle> createState() => _AnimatedProgressCircleState();
}

class _AnimatedProgressCircleState extends State<AnimatedProgressCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;
  bool _showGlow = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _anim = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _anim.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.progress == 1.0) {
        setState(() => _showGlow = true);
      }
    });
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedProgressCircle old) {
    super.didUpdateWidget(old);
    if (old.progress != widget.progress) {
      _showGlow = false;
      _ctrl
        ..duration = const Duration(milliseconds: 3000)
        ..reset();
      _anim = Tween<double>(begin: 0.0, end: widget.progress).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
      )..addStatusListener((status) {
        if (status == AnimationStatus.completed && widget.progress == 1.0) {
          setState(() => _showGlow = true);
        }
      });
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      padding: const EdgeInsets.all(4),
      decoration:
          _showGlow
              ? BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.7),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              )
              : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 45,
            height: 45,
            child: AnimatedBuilder(
              animation: _anim,
              builder:
                  (_, __) => Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: _anim.value,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
                        strokeWidth: 5,
                        color:
                            widget.progress == 1.0
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                      ),
                      Text(
                        '${(_anim.value * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
