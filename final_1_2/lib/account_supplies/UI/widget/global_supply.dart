library lib.globals;

import 'package:barcode1/account_supplies/model/model_supply.dart';

String date = '';

String chooseDate = '';

var b;

List<int> supplier = [];

bool showChildWidget = true;

bool enableDatePicker = true;

// Add Purchase

String addPurchaseDate = '';
int SupplierId = 0;

String SupplierName = '';

String _selectedDateE = '';

int SupplierIdS = 0;


String ChooseType =  '';

//Map<String, Map<String, String>> productMap = {'0': {}};

Map<String, Map<String, String>> productMap = {};
Map<String, Map<String, String>> productMapL = {};

Map<String, Map<String, String>> productMapEdit = {};


double totalAmount = 0;
double totalAmountL = 0;

bool AddPayment = false;

int mainSupplier = -1;

bool productMapE1 = false;

List<Supply> supply5 = [];
String lastOrderId = '';
  double selectedOrderTotal = 0;
  bool activate = false;

  List<Supply> supplyAll = [];