import 'package:flutter/material.dart';
import '../../../../../common/custom_shimmer.dart';
import '../../../../../common/widgets/appname_widget.dart';
import '../../../../../core/theme/custom_colors.dart';
import '../widgets/category_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    List<String> fruitsList = [
      'apple',
      'ornge',
      'pine_apple',
      'grapes',
      'banana',
      'strawberry',
    ];

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

            Container(
              padding: const EdgeInsets.only(left: 25),
              height: 40,
              child: fruitsList.isNotEmpty
                  ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        return CategoryTile(
                          onPressed: () {
                            // controller.selectCategory(
                            //     controller.allCategories[index]);
                          },
                          category: fruitsList[index],
                          isSelected: true,
                        );
                      },
                      separatorBuilder: (_, index) => const SizedBox(width: 10),
                      itemCount: fruitsList.length,
                    )
                  : ListView(
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
            ),
          ],
        ),
      ),
    );
  }
}
