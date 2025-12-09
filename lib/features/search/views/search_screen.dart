import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/skye_theme.dart';
import '../viewmodels/search_viewmodel.dart';
import '../viewmodels/search_state.dart';
import '../../home/viewmodels/home_viewmodel.dart';
import '../../../data/models/location_model.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: SkyeColors.deepSpace,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Header with back button, search bar, region filter, and favorites
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: SkyeColors.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: SkyeColors.whitePure,
                        size: 22,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Search bar
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: SkyeColors.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        style: const TextStyle(
                          color: SkyeColors.whitePure,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search city...',
                          hintStyle: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: SkyeColors.whitePure,
                            size: 20,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear_rounded,
                                    color: Color(0xFF9CA3AF),
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    ref.read(searchProvider.notifier).clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                          if (value.length >= 3) {
                            ref.read(searchProvider.notifier).searchLocation(value);
                          } else {
                            ref.read(searchProvider.notifier).clear();
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Region filter button
                  GestureDetector(
                    onTap: () => _showRegionFilterDialog(searchState),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: SkyeColors.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.filter_list_rounded,
                        color: searchState.regionFilter != RegionFilter.all
                            ? const Color(0xFF3B82F6)
                            : SkyeColors.whitePure,
                        size: 22,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Favorites toggle
                  GestureDetector(
                    onTap: () {
                      ref.read(searchProvider.notifier).toggleShowFavorites();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: SkyeColors.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        searchState.showFavoritesOnly
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: searchState.showFavoritesOnly
                            ? const Color(0xFF3B82F6)
                            : SkyeColors.whitePure,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Results
            Expanded(
              child: searchState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF3B82F6),
                      ),
                    )
                  : searchState.error != null
                      ? _buildErrorState(searchState.error!)
                      : searchState.filteredResults.isEmpty
                          ? _buildEmptyState(searchState.showFavoritesOnly)
                          : _buildResultsList(searchState.filteredResults),
            ),
          ],
        ),
      ),
    );
  }

  void _showRegionFilterDialog(SearchState state) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: SkyeColors.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Region',
                style: TextStyle(
                  color: SkyeColors.whitePure,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              _buildRegionOption(RegionFilter.all, 'All Regions', Icons.public_rounded),
              _buildRegionOption(RegionFilter.africa, 'Africa', Icons.explore_rounded),
              _buildRegionOption(RegionFilter.asia, 'Asia', Icons.explore_rounded),
              _buildRegionOption(RegionFilter.europe, 'Europe', Icons.explore_rounded),
              _buildRegionOption(RegionFilter.northAmerica, 'North America', Icons.explore_rounded),
              _buildRegionOption(RegionFilter.southAmerica, 'South America', Icons.explore_rounded),
              _buildRegionOption(RegionFilter.oceania, 'Oceania', Icons.explore_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegionOption(RegionFilter filter, String label, IconData icon) {
    final searchState = ref.watch(searchProvider);
    final isSelected = searchState.regionFilter == filter;

    return GestureDetector(
      onTap: () {
        ref.read(searchProvider.notifier).setRegionFilter(filter);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF3B82F6).withOpacity(0.2)
              : SkyeColors.deepSpace,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: const Color(0xFF3B82F6), width: 2)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? const Color(0xFF3B82F6) : SkyeColors.whitePure,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF3B82F6) : SkyeColors.whitePure,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(List<LocationModel> results) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final location = results[index];
        final isFav = ref.read(searchProvider.notifier).isFavorite(location);

        return GestureDetector(
          onTap: () {
            ref.read(homeProvider.notifier).loadWeatherForLocation(
                  location.lat,
                  location.lon,
                );
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: SkyeColors.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 14),

                // Location info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: const TextStyle(
                          color: SkyeColors.whiteFA,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        location.displayName,
                        style: const TextStyle(
                          color: SkyeColors.whiteF6,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Favorite button
                GestureDetector(
                  onTap: () async {
                    if (isFav) {
                      await ref
                          .read(searchProvider.notifier)
                          .removeFavorite(location);
                    } else {
                      final customName = await _showCustomNameDialog(location);
                      await ref
                          .read(searchProvider.notifier)
                          .addFavorite(location, customName: customName);
                    }
                  },
                  child: Icon(
                    isFav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFav ? const Color(0xFF3B82F6) : const Color(0xFF9CA3AF),
                    size: 22,
                  ),
                ),

                const SizedBox(width: 4),

                // Arrow
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF9CA3AF),
                  size: 24,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool showingFavorites) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: SkyeColors.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              showingFavorites
                  ? Icons.favorite_border_rounded
                  : Icons.search_rounded,
              size: 40,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            showingFavorites ? 'No favorites yet' : 'Search for a city',
            style: const TextStyle(
              color: SkyeColors.whiteFA,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            showingFavorites
                ? 'Add cities to favorites to see them here'
                : 'Enter at least 3 characters to search',
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: SkyeColors.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: Color(0xFFEF4444),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Search failed',
            style: TextStyle(
              color: SkyeColors.whiteFA,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              error,
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showCustomNameDialog(LocationModel location) async {
    final controller = TextEditingController();

    return await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: SkyeColors.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Custom Name',
                style: TextStyle(
                  color: SkyeColors.whiteFA,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Location: ${location.fullLocationName}',
                style: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: SkyeColors.deepSpace,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  style: const TextStyle(
                    color: SkyeColors.whitePure,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'e.g., Home, Office...',
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, controller.text.trim());
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        color: Color(0xFF3B82F6),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

