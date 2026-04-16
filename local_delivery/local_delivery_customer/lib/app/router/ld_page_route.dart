import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Base class for all feature page routes.
abstract class LDPageRoute {
  GoRoute get route;
}

/// Builds a page with a slide-from-right transition.
CustomTransitionPage<void> buildPageWithSlideTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      );
    },
  );
}

/// Builds a page with no transition (instant swap).
NoTransitionPage<void> buildPageWithNoTransition({
  required GoRouterState state,
  required Widget child,
}) {
  return NoTransitionPage<void>(key: state.pageKey, child: child);
}
