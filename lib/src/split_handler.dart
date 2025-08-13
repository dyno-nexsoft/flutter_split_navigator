import 'package:flutter/widgets.dart';

mixin SplitHandler<T extends StatefulWidget> on State<T> {
  final isSplit = ValueNotifier<bool>(false);

  double get breakpoint;

  bool canPop();

  Widget buildPrimary(BuildContext context);

  Widget buildSecondary(BuildContext context);

  @override
  void dispose() {
    isSplit.dispose();
    super.dispose();
  }

  Widget buildBody(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      isSplit.value = constraints.maxWidth > breakpoint;
      final double primaryWidth, secondaryLeft, secondaryWidth;
      if (isSplit.value) {
        primaryWidth = breakpoint / 2;
        secondaryLeft = primaryWidth;
        secondaryWidth = constraints.maxWidth - primaryWidth;
      } else {
        if (canPop() == true) {
          secondaryLeft = 0;
          secondaryWidth = constraints.maxWidth;
        } else {
          secondaryLeft = constraints.maxWidth;
          secondaryWidth = constraints.maxWidth;
        }
        primaryWidth = constraints.maxWidth;
      }

      return Stack(
        children: [
          Positioned(
            left: 0,
            width: primaryWidth,
            height: constraints.maxHeight,
            child: MediaQuery.removePadding(
              context: context,
              removeRight: isSplit.value,
              child: buildPrimary(context),
            ),
          ),
          Positioned(
            left: secondaryLeft,
            width: secondaryWidth,
            height: constraints.maxHeight,
            child: MediaQuery.removePadding(
              context: context,
              removeLeft: isSplit.value,
              child: buildSecondary(context),
            ),
          ),
        ],
      );
    });
  }
}
