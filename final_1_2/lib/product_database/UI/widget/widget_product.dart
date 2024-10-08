import 'package:barcode1/database_helper/database_helper.dart';
import 'package:barcode1/database_helper/existing_database.dart';
import 'package:barcode1/database_helper/existing_database1.dart';
import 'package:barcode1/product_database/model/product_database_model.dart';
import 'package:barcode1/product_database/operation/operation_product.dart';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProductWidget extends StatefulWidget {
  ProductWidget({super.key});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  late DatabaseHelper _dbHelper;

  String? ba1;
  _ProductWidgetState({this.ba1});

  @override
  void initState() {
    super.initState();
    //_dbHelper = DatabaseHelper.instance;

    //MyDatabase myDatabase = new MyDatabase();

    _refreshContactList();
    //_ctrlProductBarcode.text = globals.b;
  }
//var x = ba;
  // SUPPLIER

  final _formKey = GlobalKey<FormState>();

  Product _product = Product();

  static List<Product> _products = [];

  final _ctrlProductBarcode = TextEditingController();

  final _ctrlProductName = TextEditingController();
  final _ctrlProductPrice = TextEditingController();
  final _ctrlProductMeasurementUnit = TextEditingController();

  String? _barcode;
  late bool visible;

  final _dbHelper1 = ProductOperation();

  _onSubmit() async {
    var form = _formKey.currentState;
    if (_product.Id == null) {
      if (form!.validate()) {
        form.save();
        await _dbHelper1.insertProduct(_product);
        form.reset();
        await _refreshContactList();
        _resetForm();
      }
    } else {
      if (form!.validate()) {
        form.save();
        await _dbHelper1.updateProduct(_product);
        form.reset();
        await _refreshContactList();
        _resetForm();
      }
    }
  }

  _resetForm() {
    setState(() {
      _formKey.currentState!.reset();
      _product.Id = null;
      _product.Name = null;
      _product.Barcode = null;
      _product.Price = null;
      _product.MeasurementUnit = null;

      _ctrlProductBarcode.text = '';
      _ctrlProductName.text = '';
      _ctrlProductPrice.text = '';
      _ctrlProductMeasurementUnit.text = '';
    });
  }

  _showForEdit(index) {
    setState(() {
      _product = _products[index];
      _ctrlProductName.text = _products[index].Name!;
      _ctrlProductBarcode.text = _products[index].Barcode!;
      _ctrlProductPrice.text = _products[index].Price.toString();
      _ctrlProductMeasurementUnit.text = _products[index].MeasurementUnit!;
    });
  }

  // SEARCH BAR
  static List<Product> display_list = List.from(_products);

  void updateList(String value) {
    setState(() {
      display_list = _products
          .where((element) =>
              element.Name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // List View
  int index1 = 0;
  bool selected = false;

  _refreshContactList() async {
    List<Product> x = await _dbHelper1.fetchProduct();
    setState(() {
      _products = x;
      display_list = x;
      //globals.x = x;
    });
  }

  ///
  ///
  ///

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width * 0.7,
      height: height * 0.7,
      child: AlertDialog(
        alignment: Alignment.centerRight,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              width: width * 0.78,
              height: height * 0.7,
              margin: const EdgeInsets.only(left: 5, right: 10, top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  //// ROW 1/2

                  // DataTable for supplier list

                  Column(
                    children: [
                      // Search Bar

                      Container(
                        width: width * 0.58,
                        height: height * 0.05,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(123, 0, 0, 0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.only(
                            left: 8, right: 8, top: 20, bottom: 8),
                        child: TextField(
                          onChanged: (value) {
                            updateList(value);
                          },
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 19),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Search Products',
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(33, 255, 255, 255),
                                fontSize: 18,
                              ),
                              prefixIcon: const Icon(Icons.search),
                              prefixIconColor:
                                  const Color.fromARGB(33, 255, 255, 255)),
                        ),
                      ),

                      // Datatable

                      Container(
                        width: width * 0.6,
                        height: height * 0.59,
                        margin: EdgeInsets.only(top: 5,left: 0, right: 0 ,bottom: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(41, 0, 0, 0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Product Name')),
                                DataColumn(label: Text('Price')),
                                DataColumn(label: Text('Measurement Unit')),
                                DataColumn(label: Text('Delete')),
                                DataColumn(label: Text('Edit')),
                              ],
                              rows:
                                  display_list // Loops through dataColumnText, each iteration assigning the value to element
                                      .map(
                                        ((element) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text(element
                                                    .Name!)), //Extracting from Map element the value
                                                DataCell(Text(
                                                    element.Price.toString())),

                                                DataCell(Text(
                                                    element.Barcode
                                                        .toString())),

                                                DataCell(
                                                  IconButton(
                                                    onPressed: () async {
                                                      await _dbHelper1
                                                          .deleteProduct(
                                                              element.Id!);

                                                      _refreshContactList();
                                                      _resetForm();
                                                      setState(() {});
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete),
                                                  ),
                                                ),

                                                DataCell(IconButton(
                                                    onPressed: () {
                                                      _showForEdit(display_list
                                                          .indexOf(element));
                                                    },
                                                    icon: const Icon(
                                                        Icons.edit))),
                                              ],
                                            )),
                                      )
                                      .toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //// ROW 2/2

                  Column(
                    children: [
                      Container(
                        width: width * 0.172,
                        height: height * 0.6,
                        margin: const EdgeInsets.only(left: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 0, 0, 0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Container(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 15,
                                          left: 4,
                                          right: 4,
                                          bottom: 5),
                                      child: TextFormField(
                                        controller: _ctrlProductBarcode,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(Icons.person),
                                          prefixIconColor: Colors.white,

                                          floatingLabelStyle:
                                              TextStyle(color: Colors.white),

                                          enabledBorder: OutlineInputBorder(
                                            //Outline border type for TextFeild
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 3,
                                            ),
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                            //Outline border type for TextFeild
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 3,
                                            ),
                                          ),

                                          labelStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          //counterStyle: TextStyle(color: Colors.white, ),
                                          labelText: 'Product Barcode',
                                        ),
                                        validator: (val) {
                                          // ignore: prefer_is_empty
                                          if (val == null || val.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                        onSaved: (val) => setState(
                                            () => _product.Barcode = val),
                                      ),
                                    ),

                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 10,
                                          left: 4,
                                          right: 4,
                                          bottom: 5),
                                      child: TextFormField(
                                        style: const TextStyle(
                                            color: Colors.white),
                                        controller: _ctrlProductName,
                                        decoration: const InputDecoration(
                                            prefixIcon: Icon(Icons.phone),
                                            prefixIconColor: Colors.white,
                                            floatingLabelStyle:
                                                TextStyle(color: Colors.white),
                                            enabledBorder: OutlineInputBorder(
                                              //Outline border type for TextFeild
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 3,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              //Outline border type for TextFeild
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 3,
                                              ),
                                            ),
                                            labelStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            labelText: 'Product Name'),
                                        validator: (val) {
                                          // ignore: prefer_is_empty
                                          if (val == null || val.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                        onSaved: (val) =>
                                            setState(() => _product.Name = val),
                                      ),
                                    ),

                                    //barcode
                                    Container(
                                        width: width * 0.001,
                                        height: height * 0.001,
                                        child: VisibilityDetector(
                                          onVisibilityChanged:
                                              (VisibilityInfo info) {
                                            visible = info.visibleFraction > 0;
                                          },
                                          key:
                                              const Key('visible-detector-key'),
                                          child: BarcodeKeyboardListener(
                                            bufferDuration: const Duration(
                                                milliseconds: 200),
                                            onBarcodeScanned: (barcode) {
                                              if (!visible) {
                                                return;
                                              }
                                              print(barcode);
                                              setState(() {
                                                _ctrlProductBarcode.text =
                                                    barcode;
                                                _product.Barcode = barcode;

                                                //_supply.productId = p0.item?.ProductId.toString();

                                                //_refreshProductList(p0.item?.ProductId);

                                                //print(p0.item?.ProductId.toString());
                                              });
                                            },
                                            child: Text(
                                              _barcode == null
                                                  ? 'SCAN BARCODE'
                                                  : 'BARCODE: $_barcode',
                                            ),
                                          ),
                                        )),

                                    // Price

                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 10,
                                          left: 4,
                                          right: 4,
                                          bottom: 5),
                                      child: TextFormField(
                                        style: const TextStyle(
                                            color: Colors.white),
                                        controller: _ctrlProductPrice,
                                        decoration: const InputDecoration(
                                            prefixIcon: Icon(Icons.phone),
                                            prefixIconColor: Colors.white,
                                            floatingLabelStyle:
                                                TextStyle(color: Colors.white),
                                            enabledBorder: OutlineInputBorder(
                                              //Outline border type for TextFeild
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 3,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              //Outline border type for TextFeild
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 3,
                                              ),
                                            ),
                                            labelStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            labelText: 'Price'),
                                        validator: (val) {
                                          // ignore: prefer_is_empty
                                          if (val == null || val.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                        onSaved: (val) => setState(() =>
                                            _product.Price =
                                                double.parse(val!)),
                                      ),
                                    ),

                                    //measurement unit

                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 10,
                                          left: 4,
                                          right: 4,
                                          bottom: 5),
                                      child: TextFormField(
                                        style: const TextStyle(
                                            color: Colors.white),
                                        controller: _ctrlProductMeasurementUnit,
                                        decoration: const InputDecoration(
                                            prefixIcon: Icon(Icons.phone),
                                            prefixIconColor: Colors.white,
                                            floatingLabelStyle:
                                                TextStyle(color: Colors.white),
                                            enabledBorder: OutlineInputBorder(
                                              //Outline border type for TextFeild
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 3,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              //Outline border type for TextFeild
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 3,
                                              ),
                                            ),
                                            labelStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            labelText: 'Measurement Unit'),
                                        validator: (val) {
                                          // ignore: prefer_is_empty
                                          if (val == null || val.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                        onSaved: (val) => setState(() =>
                                            _product.MeasurementUnit = val),
                                      ),
                                    ),

                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 10,
                                          left: 4,
                                          right: 4,
                                          bottom: 15),
                                      width: width * 0.174,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                const MaterialStatePropertyAll(
                                                    Colors.white),
                                            shape: MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)))),
                                        onPressed: () async {
                                          var form = _formKey.currentState;
                                          if (_product.Id == null) {
                                            if (form!.validate()) {
                                              form.save();
                                             
                                              form.reset();
                                              await _refreshContactList();
                                              _resetForm();
                                              print('printed');
                                            }
                                          } else {
                                            if (form!.validate()) {
                                              form.save();
                                              await _dbHelper1
                                                  .updateProduct(_product);
                                              form.reset();
                                              await _refreshContactList();
                                              _resetForm();
                                            }
                                          }

                                          _refreshContactList();

                                          _resetForm();
                                          setState(() {});
                                        },
                                        child: const Text('Submit',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Column 2/2
                    ],
                  )
                ],
              ));
        }),
      ),
    );
  }
}
