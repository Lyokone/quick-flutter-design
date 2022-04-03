import 'package:flutter/material.dart';

class ExpandableBottomSheet extends StatefulWidget {
  /// [expandableContent] is the widget which you can hide and show by dragging.
  /// It has to be a widget with a constant height. It is required for the [ExpandableBottomSheet].
  final Widget expandableContent;

  /// [background] is the widget behind the [expandableContent] which holds
  /// usually the content of your page. It is required for the [ExpandableBottomSheet].
  final Widget background;

  /// [persistentContentHeight] is the height of the content which will never
  /// been contracted. It only relates to [expandableContent]. [persistentHeader]
  /// and [persistentFooter] will not be affected by this.
  final double persistentContentHeight;

  /// [animationDurationExtend] is the duration for the animation if you stop
  /// dragging with high speed.
  final Duration animationDurationExtend;

  /// [animationDurationContract] is the duration for the animation to bottom
  /// if you stop dragging with high speed. If it is `null` [animationDurationExtend] will be used.
  final Duration animationDurationContract;

  /// [animationCurveExpand] is the curve of the animation for expanding
  /// the [expandableContent] if the drag ended with high speed.
  final Curve animationCurveExpand;

  /// [animationCurveContract] is the curve of the animation for contracting
  /// the [expandableContent] if the drag ended with high speed.
  final Curve animationCurveContract;

  /// [onIsExtendedCallback] will be executed if the extend reaches its maximum.
  final Function()? onIsExtendedCallback;

  /// [onIsContractedCallback] will be executed if the extend reaches its minimum.
  final Function()? onIsContractedCallback;

  /// [onOffsetChanged] will be executed if the offset changes.
  final Function(double?, double?, double?)? onOffsetChanged;

  /// [enableToggle] will enable tap to toggle option on header.
  final bool enableToggle;

  /// [isDraggable] will make the [ExpandableBottomSheet] draggable by the user or not.
  final bool isDraggable;

  /// Creates the [ExpandableBottomSheet].
  ///
  /// [persistentContentHeight] has to be greater 0.
  const ExpandableBottomSheet({
    Key? key,
    required this.expandableContent,
    required this.background,
    this.persistentContentHeight = 0.0,
    this.animationCurveExpand = Curves.ease,
    this.animationCurveContract = Curves.ease,
    this.animationDurationExtend = const Duration(milliseconds: 350),
    this.animationDurationContract = const Duration(milliseconds: 350),
    this.onIsExtendedCallback,
    this.onOffsetChanged,
    this.onIsContractedCallback,
    this.enableToggle = false,
    this.isDraggable = true,
  })  : assert(persistentContentHeight >= 0),
        super(key: key);

  @override
  ExpandableBottomSheetState createState() => ExpandableBottomSheetState();
}

class ExpandableBottomSheetState extends State<ExpandableBottomSheet>
    with TickerProviderStateMixin {
  final GlobalKey _contentKey = GlobalKey(debugLabel: 'contentKey');

  late AnimationController _controller;

  double _draggableHeight = 0;
  double? _positionOffset;
  double _startOffsetAtDragDown = 0;
  double? _startPositionAtDragDown = 0;

  double _minOffset = 0;
  double _maxOffset = 0;

  double _animationMinOffset = 0;

  AnimationStatus _oldStatus = AnimationStatus.dismissed;

  bool _useDrag = true;
  bool _callCallbacks = false;

  /// Expands the content of the widget.
  void expand() {
    _afterUpdateWidgetBuild(false);
    _callCallbacks = true;
    _animateToTop();
  }

  /// Contracts the content of the widget.
  void contract() {
    _afterUpdateWidgetBuild(false);
    _callCallbacks = true;
    _animateToBottom();
  }

  /// The status of the expansion.
  ExpansionStatus get expansionStatus {
    if (_positionOffset == null) return ExpansionStatus.contracted;
    if (_positionOffset == _maxOffset) return ExpansionStatus.contracted;
    if (_positionOffset == _minOffset) return ExpansionStatus.expanded;
    return ExpansionStatus.middle;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _controller.addStatusListener(_handleAnimationStatusUpdate);
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _afterUpdateWidgetBuild(true));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _afterUpdateWidgetBuild(false));
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: widget.background,
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (_, Widget? child) {
                  if (_controller.isAnimating) {
                    _positionOffset = _animationMinOffset +
                        _controller.value * _draggableHeight;
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      widget.onOffsetChanged
                          ?.call(_positionOffset, _minOffset, _maxOffset);
                    });
                  }
                  return Positioned(
                    top: _positionOffset,
                    right: 0.0,
                    left: 0.0,
                    child: child!,
                  );
                },
                child: GestureDetector(
                  onTap: _toggle,
                  onVerticalDragDown: widget.isDraggable ? _dragDown : (_) {},
                  onVerticalDragUpdate:
                      widget.isDraggable ? _dragUpdate : (_) {},
                  onVerticalDragEnd: widget.isDraggable ? _dragEnd : (_) {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        key: _contentKey,
                        child: widget.expandableContent,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _handleAnimationStatusUpdate(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_oldStatus == AnimationStatus.forward) {
        setState(() {
          _draggableHeight = _maxOffset - _minOffset;
          _positionOffset = _minOffset;
        });
        if (widget.onIsExtendedCallback != null && _callCallbacks) {
          widget.onIsExtendedCallback!();
        }
      }
      if (_oldStatus == AnimationStatus.reverse) {
        setState(() {
          _draggableHeight = _maxOffset - _minOffset;
          _positionOffset = _maxOffset;
        });
        if (widget.onIsContractedCallback != null && _callCallbacks) {
          widget.onIsContractedCallback!();
        }
      }
    }
  }

  void _afterUpdateWidgetBuild(bool isFirstBuild) {
    double contentHeight = _contentKey.currentContext!.size!.height;

    double checkedPersistentContentHeight =
        (widget.persistentContentHeight < contentHeight)
            ? widget.persistentContentHeight
            : contentHeight;

    final newMinOffset = context.size!.height - contentHeight;
    final newMaxOffset = context.size!.height - checkedPersistentContentHeight;

    if (_minOffset == newMinOffset && _maxOffset == newMaxOffset) return;

    _minOffset = newMinOffset;
    _maxOffset = newMaxOffset;

    if (!isFirstBuild) {
      _positionOutOfBounds();
    } else {
      setState(() {
        _positionOffset = _maxOffset;
        _draggableHeight = _maxOffset - _minOffset;
      });
    }
    widget.onOffsetChanged?.call(_positionOffset, _minOffset, _maxOffset);
  }

  void _positionOutOfBounds() {
    if (_positionOffset! < _minOffset) {
      //the extend is larger than contentHeight
      _callCallbacks = false;
      _animateToMin();
    } else {
      if (_positionOffset! > _maxOffset) {
        //the extend is smaller than persistentContentHeight
        _callCallbacks = false;
        _animateToMax();
      } else {
        _draggableHeight = _maxOffset - _minOffset;
      }
    }
  }

  void _animateOnIsAnimating() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  void _toggle() {
    if (widget.enableToggle) {
      if (expansionStatus == ExpansionStatus.expanded) {
        _callCallbacks = true;
        _animateToBottom();
      }
      if (expansionStatus == ExpansionStatus.contracted) {
        _callCallbacks = true;
        _animateToTop();
      }
    }
  }

  void _dragDown(DragDownDetails details) {
    if (_controller.isAnimating) {
      _useDrag = false;
    } else {
      _useDrag = true;
      _startOffsetAtDragDown = details.localPosition.dy;
      _startPositionAtDragDown = _positionOffset;
    }
  }

  void _dragUpdate(DragUpdateDetails details) {
    if (!_useDrag) return;
    double offset = details.localPosition.dy;
    double newOffset =
        _startPositionAtDragDown! + offset - _startOffsetAtDragDown;
    if (_minOffset <= newOffset && _maxOffset >= newOffset) {
      setState(() {
        _positionOffset = newOffset;
      });
    } else {
      if (_minOffset > newOffset) {
        setState(() {
          _positionOffset = _minOffset;
        });
      }
      if (_maxOffset < newOffset) {
        setState(() {
          _positionOffset = _maxOffset;
        });
      }
    }
    widget.onOffsetChanged?.call(_positionOffset, _minOffset, _maxOffset);
  }

  void _dragEnd(DragEndDetails details) {
    if (_startPositionAtDragDown == _positionOffset || !_useDrag) return;
    if (details.primaryVelocity! < -250) {
      //drag up ended with high speed
      _callCallbacks = true;
      _animateToTop();
    } else {
      if (details.primaryVelocity! > 250) {
        //drag down ended with high speed
        _callCallbacks = true;
        _animateToBottom();
      } else {
        if (_positionOffset == _maxOffset &&
            widget.onIsContractedCallback != null) {
          widget.onIsContractedCallback!();
        }
        if (_positionOffset == _minOffset &&
            widget.onIsExtendedCallback != null) {
          widget.onIsExtendedCallback!();
        }
      }
    }
    widget.onOffsetChanged?.call(_positionOffset, _minOffset, _maxOffset);
  }

  void _animateToTop() {
    _animateOnIsAnimating();
    _controller.value = (_positionOffset! - _minOffset) / _draggableHeight;
    _animationMinOffset = _minOffset;
    _oldStatus = AnimationStatus.forward;
    _controller.animateTo(
      0.0,
      duration: widget.animationDurationExtend,
      curve: widget.animationCurveExpand,
    );
  }

  void _animateToBottom() {
    _animateOnIsAnimating();

    _controller.value = (_positionOffset! - _minOffset) / _draggableHeight;
    _animationMinOffset = _minOffset;
    _oldStatus = AnimationStatus.reverse;
    _controller.animateTo(
      1.0,
      duration: widget.animationDurationContract,
      curve: widget.animationCurveContract,
    );
  }

  void _animateToMax() {
    _animateOnIsAnimating();

    _controller.value = 1.0;
    _draggableHeight = _positionOffset! - _maxOffset;
    _animationMinOffset = _maxOffset;
    _oldStatus = AnimationStatus.reverse;
    _controller.animateTo(
      0.0,
      duration: widget.animationDurationExtend,
      curve: widget.animationCurveExpand,
    );
  }

  void _animateToMin() {
    _animateOnIsAnimating();

    _controller.value = 1.0;
    _draggableHeight = _positionOffset! - _minOffset;
    _animationMinOffset = _minOffset;
    _oldStatus = AnimationStatus.forward;
    _controller.animateTo(
      0.0,
      duration: widget.animationDurationContract,
      curve: widget.animationCurveContract,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// The status of the expandable content.
enum ExpansionStatus {
  expanded,
  middle,
  contracted,
}
