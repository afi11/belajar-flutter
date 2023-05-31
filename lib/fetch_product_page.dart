import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/product_model.dart';

class FetchProductPage extends StatefulWidget {
  const FetchProductPage({super.key});

  @override
  State<FetchProductPage> createState() => _FetchProductPageState();
}

class _FetchProductPageState extends State<FetchProductPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  ProductModel? dataFromApi;
  _getData() async {
    try {
      String url = "https://dummyjson.com/products";
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        dataFromApi = ProductModel.fromJson(json.decode(res.body));
        _isLoading = false;
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("REST API Example"),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(
                          dataFromApi!.products[index].thumbnail,
                          width: 100,
                        ),
                        Text(dataFromApi!.products[index].title.toString()),
                        Text(
                            "\$${dataFromApi!.products[index].price.toString()}")
                      ]),
                );
              },
              itemCount: dataFromApi!.products.length,
            ),
    );
  }
}
