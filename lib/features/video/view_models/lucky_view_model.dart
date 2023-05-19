import 'package:flutter_riverpod/flutter_riverpod.dart';

class LuckyViewModel extends StateNotifier<bool> {
  LuckyViewModel() : super(false);

  bool get isLucky {
    return state;
  }

  void toggleLucky() {
    state = !state;
  }

  void setLucky() {
    state = true;
  }

  void setUnLucky() {
    state = false;
  }
}

final luckyProvider = StateNotifierProvider<LuckyViewModel, bool>((ref) {
  return LuckyViewModel();
});
