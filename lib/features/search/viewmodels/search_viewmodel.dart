import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'search_state.dart';
import '../../../data/models/location_model.dart';
import '../../../core/providers/providers.dart';

class SearchNotifier extends StateNotifier<SearchState> {
  final Ref ref;

  SearchNotifier(this.ref) : super(SearchState()) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final storageService = ref.read(storageServiceProvider);
      final favorites = await storageService.getFavorites();
      state = state.copyWith(favorites: favorites);
    } catch (e) {
      // Ignore errors when loading favorites
    }
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty || query.length < 3) {
      state = state.copyWith(searchResults: [], clearError: true);
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final apiService = ref.read(apiServiceProvider);
      final results = await apiService.searchLocation(query);

      state = state.copyWith(
        isLoading: false,
        searchResults: results,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addFavorite(LocationModel location, {String? customName}) async {
    try {
      final storageService = ref.read(storageServiceProvider);
      final locationWithCustomName = customName != null
          ? location.copyWith(customName: customName)
          : location;
      await storageService.addFavorite(locationWithCustomName);
      await _loadFavorites();
    } catch (e) {
      state = state.copyWith(error: 'Failed to add favorite');
    }
  }

  Future<void> removeFavorite(LocationModel location) async {
    try {
      final storageService = ref.read(storageServiceProvider);
      await storageService.removeFavorite(location.lat, location.lon);
      await _loadFavorites();
    } catch (e) {
      state = state.copyWith(error: 'Failed to remove favorite');
    }
  }

  Future<void> updateCustomName(LocationModel location, String? customName) async {
    try {
      final storageService = ref.read(storageServiceProvider);
      await storageService.updateFavoriteCustomName(
        location.lat,
        location.lon,
        customName,
      );
      await _loadFavorites();
    } catch (e) {
      state = state.copyWith(error: 'Failed to update custom name');
    }
  }

  bool isFavorite(LocationModel location) {
    return state.favorites.any(
      (fav) => fav.lat == location.lat && fav.lon == location.lon
    );
  }

  void setRegionFilter(RegionFilter filter) {
    state = state.copyWith(regionFilter: filter);
  }

  void toggleShowFavorites() {
    state = state.copyWith(showFavoritesOnly: !state.showFavoritesOnly);
  }

  void clear() {
    state = state.copyWith(
      searchResults: [],
      clearError: true,
    );
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref);
});

