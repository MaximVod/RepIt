import 'dart:math';

import 'package:flutter/material.dart';
import 'package:repit/src/feature/cards/model/card_entity.dart';

///Card for carousel
class CardItem extends StatefulWidget {
  ///Card entity
  final CardEntity card;

  ///Card for carousel creating
  const CardItem({required this.card, super.key});

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween(end: 1.0, begin: 0.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _animationStatus = status;
      });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          if (_animationStatus == AnimationStatus.dismissed) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        },
        child: Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(2, 3, 0.0015)
            ..rotateY(pi * _animation.value),
          child: SizedBox(
            height: 200,
            width: 300,
            child: Card(
              color: _animation.value <= 0.5
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              child: Center(
                child: _animation.value <= 0.5

                    ///When the card is closed
                    ? Text(
                        widget.card.key,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      )

                    ///When the card is opened
                    : Transform.flip(
                        flipX: true,
                        child: Text(
                          widget.card.value,
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      );
}
