import 'package:flutter/material.dart';
import 'package:flutter_webview_sample/res/constants.dart';
import 'package:flutter_webview_sample/widgets/divider.dart';

class ColorOnTapDividerListView extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final Future<void> Function(int index)? onTap;
  final bool Function(int index)? isShouldHighlihgt;
  final Color highlightColor;
  final Color? defaultColor;
  final Widget Function(int index)? dividerBuilder;
  final Duration? highlightAnimationDuration;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry padding;
  final bool? shrinkWrap;

  const ColorOnTapDividerListView({
    required this.itemBuilder,
    required this.itemCount,
    required this.highlightColor,
    this.scrollController,
    this.highlightAnimationDuration,
    this.defaultColor,
    this.onTap,
    this.isShouldHighlihgt,
    this.physics,
    this.dividerBuilder,
    this.padding = const EdgeInsets.all(0),
    this.shrinkWrap,
    Key? key,
  }) : super(key: key);

  @override
  State createState() => ColorOnTapDividerState();
}

class ColorOnTapDividerState extends State<ColorOnTapDividerListView> {
  int? onTappedIndex;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      type: MaterialType.transparency,
      child: ListView.separated(
        key: const Key('work_divider_list_view'),
        controller: widget.scrollController,
        shrinkWrap: widget.shrinkWrap ?? true,
        primary: false,
        padding: widget.padding,
        physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
        itemCount: widget.itemCount,
        itemBuilder: (context, index) {
          final isHighlighted = (onTappedIndex == index) &&
              (widget.isShouldHighlihgt?.call(index) ?? true);
          return AnimatedContainer(
            color: isHighlighted
                ? widget.highlightColor
                : (widget.defaultColor ?? Colors.transparent),
            duration: !isHighlighted
                ? (widget.highlightAnimationDuration ?? Duration.zero)
                : Duration.zero,
            child: InkWell(
              overlayColor: MaterialStateColor.resolveWith(
                (states) => Colors.transparent,
              ),
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTapCancel: () {
                setState(() {
                  onTappedIndex = null;
                });
              },
              onTapDown: (details) {
                setState(() {
                  onTappedIndex = index;
                });
              },
              onTap: () async {
                setState(() {
                  onTappedIndex = index;
                });
                await widget.onTap?.call(index);
                setState(() {
                  onTappedIndex = null;
                });
              },
              child: widget.itemBuilder(context, index),
            ),
          );
        },
        separatorBuilder: (context, index) {
          Color? getColor() {
            if (onTappedIndex == null) {
              return null;
            }

            if (widget.itemCount == 1) {
              return null;
            }

            final shouldHighlightCurrentIndex =
                (widget.isShouldHighlihgt?.call(index) ?? true);

            if ((onTappedIndex! - 1 == index &&
                (!(widget.isShouldHighlihgt?.call(index + 1) ?? true)))) {
              return null;
            }
            if (!shouldHighlightCurrentIndex) {
              return null;
            }

            if (onTappedIndex == 0 && index == 0) {
              return widget.highlightColor;
            }

            if (onTappedIndex == widget.itemCount - 1 &&
                index == onTappedIndex! - 1) {
              return widget.highlightColor;
            }

            if (onTappedIndex == index || index == onTappedIndex! - 1) {
              return widget.highlightColor;
            }
            return null;
          }

          final color = getColor();
          return AnimatedContainer(
            color: color ?? widget.defaultColor ?? Colors.transparent,
            duration: color == null
                ? (widget.highlightAnimationDuration ?? Duration.zero)
                : Duration.zero,
            child: widget.dividerBuilder?.call(index) ??
                Padding(
                  padding: const EdgeInsets.only(left: middlePadding),
                  child: SimpleDivider(
                    widget.highlightColor,
                  ),
                ),
          );
        },
      ),
    );
  }
}
