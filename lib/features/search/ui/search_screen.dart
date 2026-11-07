import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/enums.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/text_styles.dart';
import '../../../core/widgets/custom_empty_state_widget.dart';
import '../../../core/widgets/custom_error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/meal_card.dart';
import '../logic/search_cubit.dart';
import '../logic/search_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyles.font18BoneSemiBold.copyWith(
            fontFamily: 'serif',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Semantics(
              // Exposes the search field to mobile e2e tests (getByTestId).
              identifier: 'search-field',
              container: true,
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onChanged: (query) {
                  setState(() {});
                  context.read<SearchCubit>().onSearchChanged(query);
                },
                onSubmitted: (query) =>
                    context.read<SearchCubit>().searchMeals(query),
                decoration: InputDecoration(
                  hintText: 'Search for a meal (in English)...',
                  hintStyle: TextStyles.font14Grey.copyWith(
                    color: isDark
                        ? ColorsManager.darkGroundMuted
                        : Color.lerp(ColorsManager.cumin, ColorsManager.umber, 0.4)!,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: ColorsManager.mutedInk(brightness),
                  ),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: ColorsManager.mutedInk(brightness),
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                            context.read<SearchCubit>().searchMeals('');
                          },
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  switch (state.status) {
                    case RequestStatus.initial:
                      return const CustomEmptyStateWidget(
                        icon: Icons.manage_search_rounded,
                        title: 'Search for recipes',
                        subtitle:
                            'Type the name of any meal in English and press search.',
                      );
                    case RequestStatus.loading:
                      return const LoadingWidget();
                    case RequestStatus.error:
                      return CustomErrorWidget(
                        errorMessage:
                            state.errorMessage ?? 'Something went wrong.',
                        onRetry: () => context
                            .read<SearchCubit>()
                            .searchMeals(state.query),
                      );
                    case RequestStatus.success:
                      if (state.meals.isEmpty) {
                        return CustomEmptyStateWidget(
                          icon: Icons.search_off_rounded,
                          title: 'No meals found',
                          subtitle:
                              'There are no recipes matching "${state.query}".',
                        );
                      }
                      // After the quiet debounce, one 400 ms overshoot
                      // pulse lands the new results — once per search.
                      return TweenAnimationBuilder<double>(
                        key: ValueKey<String>('search-results-${state.query}'),
                        tween: Tween<double>(begin: 0.96, end: 1),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutBack,
                        builder: (context, scale, child) =>
                            Transform.scale(scale: scale, child: child),
                        child: GridView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.82,
                          ),
                          itemCount: state.meals.length,
                          itemBuilder: (context, index) {
                            return MealCard(meal: state.meals[index]);
                          },
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
