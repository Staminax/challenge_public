import 'package:bemagro_weather/shared/search_history/search_history.dart';
import 'package:bemagro_weather/shared/search_history/search_history_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchHistoryProvider =
    StateNotifierProvider<SearchHistoryNotifier, List<SearchHistory>>((ref) {
  final controller = SearchHistoryController();
  return SearchHistoryNotifier(controller)..fetchHistory();
});

class SearchHistoryNotifier extends StateNotifier<List<SearchHistory>> {
  final SearchHistoryController searchHistoryController;

  SearchHistoryNotifier(this.searchHistoryController) : super([]);

  Future<void> addSearchHistory(SearchHistory search) async {
    await searchHistoryController.insert(search);
    await fetchHistory();
  }

  Future<void> clearHistory() async {
    await searchHistoryController.deleteAll();
    await fetchHistory();
  }

  Future<void> deleteSearchHistory(int id) async {
    await searchHistoryController.delete(id);
    await fetchHistory();
  }

  Future<void> fetchHistory() async {
    final history = await searchHistoryController.getSearchHistory();
    state = history;
  }
}
