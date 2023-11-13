import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:workshop_apis_itschool/models/category_model.dart';
import 'package:workshop_apis_itschool/models/product_model.dart';
import 'package:workshop_apis_itschool/repos/dio_helper.dart';
import 'package:workshop_apis_itschool/repos/end_points.dart';
import 'package:workshop_apis_itschool/repos/navigation_helper.dart';
import 'package:workshop_apis_itschool/screens/product_details.dart';

class ProductsCategoryScreen extends StatelessWidget {
  const ProductsCategoryScreen({super.key, required this.category});

  final CategoryModel category;

  Future<Response> _getProducts() {
    return DioHelper.dio.get("$getProductsInCategoryApiUrl${category.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name!),
      ),
      body: FutureBuilder(
        future: _getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<ProductModel> products = [];
            for (var element in snapshot.data!.data) {
              products.add(ProductModel.fromJson(element));
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    NavigationHelper.goTo(
                        ProductDetailsScreen(item: products[index]), context);
                  },
                  leading: FadeInImage(
                    width: 60,
                    height: 40,
                    fit: BoxFit.cover,
                    placeholder:
                        const AssetImage("assets/images/placeholder.png"),
                    image: NetworkImage(products[index].images![0]),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/placeholder.png",
                        width: 60,
                        height: 40,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  title: Text(products[index].title!),
                  subtitle: Text(products[index].price.toString()),
                );
              },
              itemCount: products.length,
            );
          }
        },
      ),
    );
  }
}
