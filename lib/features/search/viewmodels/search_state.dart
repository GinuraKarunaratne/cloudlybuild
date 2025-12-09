import '../../../data/models/location_model.dart';

enum RegionFilter {
  all,
  africa,
  asia,
  europe,
  northAmerica,
  southAmerica,
  oceania,
}

class SearchState {
  final bool isLoading;
  final List<LocationModel> searchResults;
  final List<LocationModel> favorites;
  final String? error;
  final RegionFilter regionFilter;
  final bool showFavoritesOnly;

  SearchState({
    this.isLoading = false,
    this.searchResults = const [],
    this.favorites = const [],
    this.error,
    this.regionFilter = RegionFilter.all,
    this.showFavoritesOnly = false,
  });

  List<LocationModel> get filteredResults {
    var results = showFavoritesOnly ? favorites : searchResults;

    if (regionFilter != RegionFilter.all && !showFavoritesOnly) {
      results = results.where((location) {
        final country = location.country.toLowerCase();
        switch (regionFilter) {
          case RegionFilter.africa:
            return _isAfricanCountry(country);
          case RegionFilter.asia:
            return _isAsianCountry(country);
          case RegionFilter.europe:
            return _isEuropeanCountry(country);
          case RegionFilter.northAmerica:
            return _isNorthAmericanCountry(country);
          case RegionFilter.southAmerica:
            return _isSouthAmericanCountry(country);
          case RegionFilter.oceania:
            return _isOceaniaCountry(country);
          default:
            return true;
        }
      }).toList();
    }

    return results;
  }

  SearchState copyWith({
    bool? isLoading,
    List<LocationModel>? searchResults,
    List<LocationModel>? favorites,
    String? error,
    RegionFilter? regionFilter,
    bool? showFavoritesOnly,
    bool clearError = false,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      searchResults: searchResults ?? this.searchResults,
      favorites: favorites ?? this.favorites,
      error: clearError ? null : (error ?? this.error),
      regionFilter: regionFilter ?? this.regionFilter,
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
    );
  }

  static bool _isAfricanCountry(String country) {
    final african = ['eg', 'za', 'ng', 'ke', 'ma', 'tz', 'gh', 'ug', 'ao', 'mz',
                     'et', 'dz', 'sd', 'tn', 'ly', 'ci', 'cm'];
    return african.contains(country);
  }

  static bool _isAsianCountry(String country) {
    final asian = ['cn', 'in', 'jp', 'kr', 'th', 'vn', 'ph', 'id', 'my', 'sg',
                   'bd', 'pk', 'mm', 'kh', 'la', 'np', 'lk', 'af', 'ir', 'iq'];
    return asian.contains(country);
  }

  static bool _isEuropeanCountry(String country) {
    final european = ['gb', 'de', 'fr', 'es', 'it', 'nl', 'be', 'pl', 'ro', 'gr',
                      'pt', 'se', 'no', 'fi', 'dk', 'ch', 'at', 'cz', 'hu', 'ie'];
    return european.contains(country);
  }

  static bool _isNorthAmericanCountry(String country) {
    final northAmerican = ['us', 'ca', 'mx', 'cu', 'gt', 'hn', 'ni', 'cr', 'pa',
                           'do', 'jm', 'ht', 'sv', 'bz'];
    return northAmerican.contains(country);
  }

  static bool _isSouthAmericanCountry(String country) {
    final southAmerican = ['br', 'ar', 'co', 've', 'pe', 'cl', 'ec', 'bo', 'py',
                           'uy', 'gy', 'sr', 'gf'];
    return southAmerican.contains(country);
  }

  static bool _isOceaniaCountry(String country) {
    final oceania = ['au', 'nz', 'fj', 'pg', 'nc', 'ws', 'to', 'vu'];
    return oceania.contains(country);
  }
}
