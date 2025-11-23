import 'package:flutter/material.dart';
import '../models/event.dart';
import 'swipe_card.dart';

class SwipeableCard extends StatefulWidget {
  final Event event;
  final Function onLike;
  final Function onDislike;

  const SwipeableCard({
    super.key,
    required this.event,
    required this.onLike,
    required this.onDislike,
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  Offset position = Offset.zero;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void animateCard(Offset endOffset, {required bool isLike}) {
    _animation = Tween<Offset>(
      begin: position,
      end: endOffset,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward().then((_) {
      if (isLike) {
        widget.onLike();
      } else {
        widget.onDislike();
      }

      _controller.reset();
      setState(() => position = Offset.zero);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          position += details.delta;
        });
      },
      onPanEnd: (details) {
        if (position.dx > 120) {
          animateCard(Offset(500, 0), isLike: true);
        } else if (position.dx < -120) {
          animateCard(Offset(-500, 0), isLike: false);
        } else {
          animateCard(Offset.zero, isLike: false);
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          Offset offset = _controller.isAnimating ? _animation.value : position;

          double rotation = offset.dx / 300;

          return Transform.translate(
            offset: offset,
            child: Transform.rotate(angle: rotation, child: child),
          );
        },
        child: SwipeCard(event: widget.event),
      ),
    );
  }
}
