import 'package:flutter/material.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:slide_countdown/src/data/config/config.dart';

/// @nodoc
class StreamDuration extends ValueNotifier<Duration> {
  /// @nodoc
  StreamDuration({
    required this.config,
  }) : super(config.duration) {
    if (config.autoPlay) play();
  }

  /// @nodoc
  final StreamDurationConfig config;

  /// @nodoc
  bool get isCountUp => config.isCountUp;

  /// @nodoc
  bool get isPaused => _timer?.isPaused ?? false;

  /// Target end time for wall-clock based countdown
  /// Used to sync countdown after app resume from background
  DateTime? _targetEndTime;

  /// Whether this is a wall-clock based countdown (vs tick-based)
  bool get isWallClockBased => _targetEndTime != null;

  /// Get the remaining duration based on wall-clock time
  /// Returns null if not wall-clock based
  Duration? get remainingFromWallClock {
    if (_targetEndTime == null) return null;
    final remaining = _targetEndTime!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  PausableTimer? _timer;

  CountUpConfig get _countUpConfig =>
      config.countUpConfig ?? CountUpConfig.defaultConfig;

  ///
  bool get isFinished {
    if (!isCountUp && value.inSeconds <= 0) return true;

    return isCountUp &&
        !_countUpConfig.isInfinity &&
        value >= _countUpConfig.maxDuration!;
  }

  void _onDone() {
    _timer?.pause();
    // ignore: avoid_dynamic_calls
    config.onDone?.call();
  }

  /// Play
  void play() {
    _timer = PausableTimer.periodic(
      config.periodic,
      () {
        if (isCountUp) {
          value += config.periodic;
        } else {
          value -= config.periodic;
        }
        notifyListeners();
        if (isFinished) _onDone();
      },
    );
    _timer?.start();
  }

  /// Start countdown with wall-clock based timing
  /// This ensures countdown syncs correctly after app resume from background
  void playWithWallClock(Duration duration) {
    _targetEndTime = DateTime.now().add(duration);
    value = duration;
    play();
  }

  /// Sync the countdown value based on wall-clock time
  /// Call this when app resumes from background
  void syncFromWallClock() {
    if (_targetEndTime == null) return;

    final remaining = _targetEndTime!.difference(DateTime.now());
    if (remaining.isNegative) {
      value = Duration.zero;
      _onDone();
    } else {
      value = remaining;
      notifyListeners();
    }
  }

  /// pause duration
  void pause() => _timer?.pause();

  /// reset duration to initial duration
  void reset() {
    value = config.duration;
    _targetEndTime = null;
    notifyListeners();
  }

  /// resume duration
  void resume() => _timer?.start();

  /// change
  @Deprecated('use seek instead')
  void change(Duration duration) {
    value = duration;
    notifyListeners();
  }

  /// seek to
  void seek(Duration duration) {
    value = duration;
    _targetEndTime = DateTime.now().add(duration);
    notifyListeners();
  }

  /// subtract duration
  void subtract(Duration duration) {
    value -= duration;
    if (_targetEndTime != null) {
      _targetEndTime = _targetEndTime!.subtract(duration);
    }
    notifyListeners();
  }

  /// add duration
  void add(Duration duration) {
    value += duration;
    if (_targetEndTime != null) {
      _targetEndTime = _targetEndTime!.add(duration);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// extension for StreamDurationConfig
extension StreamDurationConfigExtensions on StreamDurationConfig {
  /// @nodoc
  Duration get duration =>
      isCountUp ? initialCountUpDuration : initialCountDownDuration;

  /// @nodoc
  Duration get initialCountUpDuration =>
      countUpConfig?.initialDuration ?? Duration.zero;

  /// @nodoc
  Duration get initialCountDownDuration {
    if (countDownConfig == null) {
      throw Exception("countDownConfig can't be null");
    }
    return countDownConfig!.duration;
  }
}
