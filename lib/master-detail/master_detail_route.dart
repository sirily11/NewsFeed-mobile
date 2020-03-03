import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/master-detail/master_detail_container.dart';

class DetailRoute<T> extends TransitionRoute<T> with LocalHistoryRoute<T> {
  final bool forceRenderTabletView;
  DetailRoute(
      {@required WidgetBuilder this.builder,
      RouteSettings settings,
      this.forceRenderTabletView = false})
      : super(settings: settings);

  final WidgetBuilder builder;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      OverlayEntry(builder: (context) {
        return Positioned(
          left: isTablet(context) ? kMasterWidth : 0,
          top: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: forceRenderTabletView
                ? MediaQuery.of(context).size.width - kMasterWidth
                : isTablet(context)
                    ? MediaQuery.of(context).size.width - kMasterWidth
                    : MediaQuery.of(context).size.width,
            child: builder(context),
          ),
        );
      })
    ];
  }

  @override
  bool didPop(T result) {
    final bool returnValue = super.didPop(result);
    assert(returnValue);
    if (finishedWhenPopped) {
      navigator.finalizeRoute(this);
    }
    return returnValue;
  }

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 250);
}
