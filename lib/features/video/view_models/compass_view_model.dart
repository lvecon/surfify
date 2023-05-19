import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompassViewModel extends StateNotifier<bool> {
  CompassViewModel() : super(false);

  bool get isCompass {
    return state;
  }

  void setCondition() {
    state = !state;
  }
}

final compassProvider = StateNotifierProvider<CompassViewModel, bool>((ref) {
  return CompassViewModel();
});
