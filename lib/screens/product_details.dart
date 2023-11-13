import 'package:flutter/material.dart';
import 'package:workshop_apis_itschool/models/product_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.item});

  final ProductModel item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title!),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(item.images![0], height: 400),
            ListTile(title: Text(item.title!)),
            ListTile(title: Text(item.category!.name!)),
            ListTile(title: Text(item.price!.toString())),
            ListTile(title: Text(item.description!)),
          ],
        ),
      ),
    );
  }
}
