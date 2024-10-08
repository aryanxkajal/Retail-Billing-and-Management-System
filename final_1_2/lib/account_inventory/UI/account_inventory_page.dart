

import 'package:barcode1/account_inventory/UI/widget/inventory_page.dart';
import 'package:flutter/material.dart';



class AccountInventoryPage extends StatefulWidget {
  const AccountInventoryPage({Key? key}) : super(key: key);

  @override
  State<AccountInventoryPage> createState() => _AccountInventoryPageState();
}

class _AccountInventoryPageState extends State<AccountInventoryPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      body: InventoryPage(),
      
    );
  }
}
