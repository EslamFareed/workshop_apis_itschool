import 'package:flutter/material.dart';
import 'package:workshop_apis_itschool/models/product_model.dart';
import 'package:workshop_apis_itschool/repos/dio_helper.dart';
import 'package:workshop_apis_itschool/repos/end_points.dart';
import 'package:workshop_apis_itschool/repos/navigation_helper.dart';
import 'package:workshop_apis_itschool/screens/product_details.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();

  List<ProductModel> products = [];

  @override
  void initState() {
    _search();
    super.initState();
  }

  bool isLoading = false;
  void _search() {
    products = [];
    setState(() {
      isLoading = true;
    });
    DioHelper.dio
        .get("$getProductsByNameApiUrl${searchController.text}")
        .then((response) {
      for (var element in response.data) {
        products.add(ProductModel.fromJson(element));
      }
      max = products[0].price!.toDouble();
      min = products[0].price!.toDouble();
      for (var item in products) {
        if (item.price! > max) {
          max = item.price!.toDouble();
        }

        if (item.price! < min) {
          min = item.price!.toDouble();
        }
      }

      start = min;
      end = min + 10.0;

      setState(() {
        isLoading = false;
      });
    });
  }

  void _searchByPrice() {
    products = [];
    setState(() {
      isLoading = true;
    });
    DioHelper.dio.get("$getProductsByNameApiUrl${searchController.text}",
        queryParameters: {
          "price_min": start,
          "price_max": end,
        }).then((response) {
      for (var element in response.data) {
        products.add(ProductModel.fromJson(element));
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  double start = 0;
  double end = 0;

  double max = 0;
  double min = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return BottomSheet(
                    onClosing: () {},
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return SizedBox(
                            height: 400,
                            child: Column(
                              children: [
                                RangeSlider(
                                  divisions: 1000,
                                  values: RangeValues(start, end),
                                  min: min,
                                  max: max,
                                  labels: const RangeLabels(
                                    "Min Price",
                                    "Max Price",
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      start = value.start;
                                      end = value.end;
                                    });
                                  },
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${start.toInt()}"),
                                      Text("${end.toInt()}"),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _searchByPrice();
                                  },
                                  child: const Text("Filter By Price"),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchBar(
              controller: searchController,
              trailing: [
                IconButton(
                    onPressed: () {
                      _search();
                    },
                    icon: const Icon(Icons.search))
              ],
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                    ? const Center(
                        child: Text("No Data Found"),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              NavigationHelper.goTo(
                                  ProductDetailsScreen(item: products[index]),
                                  context);
                            },
                            leading: FadeInImage(
                              width: 60,
                              height: 40,
                              fit: BoxFit.cover,
                              placeholder: const AssetImage(
                                  "assets/images/placeholder.png"),
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
                      )
          ],
        ),
      ),
    );
  }
}
