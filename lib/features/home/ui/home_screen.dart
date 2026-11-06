import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/enums.dart';
import '../../../core/theming/text_styles.dart';
import '../../../core/widgets/custom_error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../logic/home_cubit.dart';
import '../logic/home_state.dart';
import 'widgets/categories_list_view.dart';
import 'widgets/meals_grid_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.categoriesStatus == RequestStatus.error) {
            return CustomErrorWidget(
              errorMessage:
                  state.errorMessage ?? 'Could not load the categories.',
              onRetry: () => context.read<HomeCubit>().loadHomeData(),
            );
          }

          if (state.categoriesStatus != RequestStatus.success) {
            return const LoadingWidget();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              CategoriesListView(
                categories: state.categories,
                selectedIndex: state.selectedCategoryIndex,
                onCategoryTap: (index) =>
                    context.read<HomeCubit>().selectCategory(index),
              ),
              Expanded(
                child: MealsGridView(
                  state: state,
                  onRetry: () => context
                      .read<HomeCubit>()
                      .selectCategory(state.selectedCategoryIndex),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What would you like to cook today?',
            style: TextStyles.font24DarkBold,
          ),
          const SizedBox(height: 4),
          Text(
            'Fresh recipes from around the world',
            style: TextStyles.font15Grey,
          ),
        ],
      ),
    );
  }
}
