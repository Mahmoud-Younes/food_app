import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/enums.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyles.font18DarkSemiBold,
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
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.grey,
                  ),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: Colors.grey),
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
                      return GridView.builder(
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
