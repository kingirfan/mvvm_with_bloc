import 'package:bloc_with_mvvm/feature/nav_screen/home/presentation/bloc/home_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/custom_shimmer.dart';
import '../../../../../common/widgets/appname_widget.dart';
import '../../../../../core/theme/custom_colors.dart';
import '../bloc/home_bloc.dart';
import '../view_models/HomePageViewModel.dart';
import '../widgets/category_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomePageViewModel homePageViewModel = HomePageViewModel();

  @override
  void initState() {
    super.initState();
    // context.read<HomePageBloc>().add(LoadCategoriesEvent());
    homePageViewModel.loadCategories(context);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const AppNameWidget(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 15),
              child: GestureDetector(
                onTap: () {
                  // navigationController.navigatePageView(NavigationTabs.cart);
                },
                child: Badge(
                  backgroundColor: CustomColors.customContrastColor,
                  label: const Text(
                    '6',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  child: Icon(
                    Icons.shopping_cart,
                    color: CustomColors.customSwatchColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  // controller.searchTitle.value = value;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  hintText: 'Pesquise aqui...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: CustomColors.customContrastColor,
                    size: 21,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchController.clear();
                      // controller.searchTitle.value = '';
                      FocusScope.of(context).unfocus();
                    },
                    icon: Icon(
                      Icons.close,
                      color: CustomColors.customContrastColor,
                      size: 21,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
              ),
            ),

            BlocBuilder<HomePageBloc, HomePageState>(
              builder: (context, state) {
                homePageViewModel.handleState(context, state);
                if (state is HomePageLoading) {
                  return SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        10,
                        (index) => Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 12),
                          child: CustomShimmer(
                            height: 20,
                            width: 80,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                if (state is HomePageCategoryLoaded) {
                  return Container(
                    padding: const EdgeInsets.only(left: 25),
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        final category = state.categories[index];
                        return CategoryTile(
                          onPressed: () {
                            homePageViewModel.onCategorySelected(
                              context,
                              category,
                            );
                          },
                          category: category.title,
                          isSelected: category.id == state.selectedCategory?.id,
                        );
                      },
                      separatorBuilder: (_, index) => const SizedBox(width: 10),
                      itemCount: state.categories.length,
                    ),
                  );
                }
                if (state is HomePageFailure) {
                  return Text(state.error.message);
                }

                return const SizedBox(); // For initial or unknown state
              },
            ),

            const SizedBox(height: 30),

            BlocBuilder<HomePageBloc, HomePageState>(
              builder: (context, state) {
                if (state is HomePageLoading) {
                  return const SizedBox(height: 40, child: Text('Loadin ....'));
                }

                if (state is HomePageProductLoaded) {
                  print('state ${state.productList}');
                  return Container(
                    padding: const EdgeInsets.only(left: 25),
                    height: 40,
                    child: Text('data ${state.productList.length}'),
                  );
                }
                if (state is HomePageFailure) {
                  return Text(state.error.message);
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
