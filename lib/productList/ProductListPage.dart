import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stic_flutter_task/productList/JsonDataProvider.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  JsonDataProvider? jsonDataProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getProducts();
  }

  void getProducts() async {
    jsonDataProvider = Provider.of<JsonDataProvider>(context, listen: false);

    await jsonDataProvider!.readProductsJson();

    await jsonDataProvider!.filterProducts("", context);

    await jsonDataProvider!.startQuantityReductionTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Product List',
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                onChanged: (value) =>
                    jsonDataProvider!.filterProducts(value, context),
                decoration: const InputDecoration(
                    labelText: 'Search by name or description', suffixIcon: Icon(Icons.search)),
              ),
            ),
            SizedBox(height: 10),
            Consumer<JsonDataProvider>(builder: (context, data, _) {
              return Expanded(
                child: ListView.builder(
                  itemCount: data.filteredProductList!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: ListTile(
                        title: Text(
                          data.filteredProductList![index].name!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        subtitle: Text(
                          data.filteredProductList![index].description!,
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Text(
                          data.filteredProductList![index].quantity!.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                      ),
                    );
                  },
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
