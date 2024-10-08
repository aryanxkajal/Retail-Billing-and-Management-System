
import 'package:barcode1/product_database/UI/widget/widget_product.dart';
import 'package:flutter/material.dart';

class ProductDatabasePage extends StatefulWidget {
  const ProductDatabasePage({Key? key}) : super(key: key);

  @override
  State<ProductDatabasePage> createState() => _ProductDatabasePageState();
}

class _ProductDatabasePageState extends State<ProductDatabasePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          Container(
            height: height,
            width: width * 0.12,
          ),
          
          
          Container(
                          width: width * 0.095,
                          height: height * 0.06,
                          margin: const EdgeInsets.only(
                              left: 5, right: 10, top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    ProductWidget(),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.black),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            child: const Text('Suppliers List',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
         
        ],
      ),
    );
  }
}