import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/video/models/searchcondition_model.dart';

class SearchConditionViewModel extends Notifier<SearchConditionModel> {
  SearchConditionViewModel();

  void setCondition(List<String> value) {
    state = SearchConditionModel(searchCondition: value);
  }

  @override
  SearchConditionModel build() {
    return SearchConditionModel(
      searchCondition: [],
    );
  }
}

final searchConditionProvider =
    NotifierProvider<SearchConditionViewModel, SearchConditionModel>(() {
  return SearchConditionViewModel();
});
