import 'package:flutter/material.dart';
import 'package:slide_countdown/slide_countdown.dart';

/// {@template should_show_items}
/// ShouldShowItems is a type alias for a function that takes a
/// `Duration` as an argument
/// and returns a `bool`.
///
/// The purpose of this typedef is to define a standard signature for functions
/// that determine whether a set of items should be shown or not
/// based on a duration.
/// {@endtemplate}
typedef ShouldShowItems = bool Function(Duration);

/// {@template override_digits}
/// Default digits is 0-9 if you need change the digits e.g
/// with arabic number you can use this.
/// {@endtemplate}
typedef OverrideDigits = List<String>;

/// The default box decoration of [SlideCountdown]
///
/// NOTE: forked for xiaozz — the upstream default red `Color(0xFFF23333)`
/// clashes with the app color scheme; use a neutral grey as a safety net
/// for any call site that forgets to pass a themed decoration.
const kDefaultBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(20)),
  color: Color(0xFF757575),
);

/// The default box decoration of [SlideCountdownSeparated]
///
/// NOTE: forked for xiaozz — see [kDefaultBoxDecoration].
const kDefaultSeparatedBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(4)),
  color: Color(0xFF757575),
);

/// The default padding
const kDefaultPadding = EdgeInsets.symmetric(
  horizontal: 10,
  vertical: 5,
);

/// The default separator padding
const kDefaultSeparatorPadding = EdgeInsets.symmetric(
  horizontal: 3,
);

/// The default text style
const kDefaultTextStyle = TextStyle(
  color: Color(0xFFFFFFFF),
  fontWeight: FontWeight.bold,
);

/// The default separator text style
const kDefaultSeparatorTextStyle =
    TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold);
