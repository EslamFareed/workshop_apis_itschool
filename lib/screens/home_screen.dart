import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:workshop_apis_itschool/models/category_model.dart';
import 'package:workshop_apis_itschool/models/product_model.dart';
import 'package:workshop_apis_itschool/repos/dio_helper.dart';
import 'package:workshop_apis_itschool/repos/end_points.dart';
import 'package:workshop_apis_itschool/repos/navigation_helper.dart';
import 'package:workshop_apis_itschool/screens/product_details.dart';
import 'package:workshop_apis_itschool/screens/products_in_category_screen.dart';
import 'package:workshop_apis_itschool/screens/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<Response> _getProdudcts() {
    return DioHelper.dio.get(getProductsApiUrl);
  }

  Future<Response> _getCategories() {
    return DioHelper.dio.get(getCategoriesApiUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              NavigationHelper.goTo(SearchScreen(), context);
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //! Categories
            FutureBuilder(
              future: _getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: const EdgeInsets.all(50),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  List<CategoryModel> categories = [];

                  for (var element in snapshot.data!.data) {
                    categories.add(CategoryModel.fromJson(element));
                  }
                  return SizedBox(
                    height: 70,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            NavigationHelper.goTo(
                                ProductsCategoryScreen(
                                    category: categories[index]),
                                context);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    blurStyle: BlurStyle.outer,
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    offset: Offset(3, 0),
                                  )
                                ]),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(categories[index].name!),
                          ),
                        );
                      },
                      itemCount: categories.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  );
                }
              },
            ),
            //! Products
            FutureBuilder(
              future: _getProdudcts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: const EdgeInsets.all(50),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  List<ProductModel> products = [];
                  for (var element in snapshot.data!.data) {
                    products.add(ProductModel.fromJson(element));
                  }
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          NavigationHelper.goTo(
                              ProductDetailsScreen(item: products[index]),
                              context);
                        },
                        child: Card(
                            child: Stack(
                          children: [
                            FadeInImage(
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                      "assets/images/placeholder.png");
                                },
                                placeholder: const AssetImage(
                                    "assets/images/placeholder.png"),
                                image:
                                    NetworkImage(products[index].images![0])),
                            // Image.network(products[index].images![0]),
                            Container(color: Colors.black54),
                            Align(
                              alignment: Alignment.center,
                              child: Text(products[index].title!),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  "${products[index].price!.toString()} \$",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        )),
                      );
                    },
                    itemCount: products.length,
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
