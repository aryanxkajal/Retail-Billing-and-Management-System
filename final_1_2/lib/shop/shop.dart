import 'package:barcode1/shop/operations/operation_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import 'model/model_store.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  void initState() {
    super.initState();

    _fetchStore();
  }

  _registerFirebase() async {
    final firestore = FirebaseFirestore.instance;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_ctrlRegisteredPhone.text)
          .collection(_ctrlRegisteredPhone.text)
          .doc('details')
          .set({
        'name': _ctrlShopName.text,
        'phone': _ctrlShopPhone.text,
        'registeredPhone': _ctrlRegisteredPhone.text,
        'address': _ctrlShopAdd.text,
        'website': '',
        'date': _ctrlDate.text,
        'registerationNumber': _ctrlCode.text,
        'licenseDuration': _ctrlValidity.text
      }).then((value) => print('store added'));
    } catch (e) {
      print('Error fetching transactions from Firestore: $e');
    }
  }

  _fetchStore() async {
    var store = await _dbHelperStore.fetchStore();

    if (store.isNotEmpty) {
      setState(() {
        _store = store.last;
        _ctrlShopName.text = store.last.name!;
        _ctrlShopPhone.text = store.last.phone!;
        _ctrlShopAdd.text = store.last.address!;
        _ctrlShopWebsite.text = store.last.website!;
        _ctrlShopCode.text = store.last.code!;
        _ctrlRegisteredPhone.text = store.last.registeredPhone!;
        _ctrlDate.text = store.last.date!;
        _ctrlValidity.text = store.last.validity!;
        _ctrlCode.text = store.last.code!;
      });
    } else {
      setState(() {
        _store = Store();
        _ctrlShopName.text = '';
        _ctrlShopPhone.text = '';
        _ctrlShopAdd.text = '';
        _ctrlShopWebsite.text = '';
      });
    }
    //_fetchRegisterationNumber(store.last.code!);
    //print(store[0].code);
  }

  final TextEditingController _ctrlRegisteredPhone = TextEditingController();
  final TextEditingController _ctrlDate = TextEditingController();
  final TextEditingController _ctrlValidity = TextEditingController();
  final TextEditingController _ctrlCode = TextEditingController();
  final TextEditingController _ctrlShopName = TextEditingController();
  final TextEditingController _ctrlUpi = TextEditingController();
  final TextEditingController _ctrlShopPhone = TextEditingController();
  final TextEditingController _ctrlShopAdd = TextEditingController();
  final TextEditingController _ctrlShopWebsite = TextEditingController();
  final TextEditingController _ctrlShopCode = TextEditingController();

  final FocusNode _shopName = FocusNode();
  String errorShopName = '';

  final FocusNode _upi = FocusNode();
  String errorUpi = '';

  final FocusNode _shopPhone = FocusNode();
  String errorShopPhone = '';

  final FocusNode _shopAdd = FocusNode();
  String errorShopAdd = '';

  final FocusNode _shopWebsite = FocusNode();
  String errorShopWebsite = '';

  Store _store = Store();

  final _dbHelperStore = StoreOperation();

  // keyboard

  // CustomLayoutKeys _customLayoutKeys;
  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  TextEditingController _controllerText = TextEditingController();
  TextEditingController _none = TextEditingController();

  _onKeyPress(VirtualKeyboardKey key, TextEditingController controller) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      controller.text =
          controller.text + (shiftEnabled ? key.capsText! : key.text!);
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (controller.text.isEmpty) return;

          controller.text =
              controller.text.substring(0, controller.text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          controller.text = controller.text + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          controller.text = controller.text + key.text!;
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }

    //product search

    if (_shopPhone.hasFocus) {
      if (int.tryParse(controller.text) == null &&
          _ctrlShopPhone.text.length > 0) {
        errorShopPhone = 'Invalid';
      } else if (_ctrlShopPhone.text.length != 10) {
        errorShopPhone = 'Invalid';
      } else {
        errorShopPhone = '';
      }
    }

    // Update the screen
    setState(() {});
  }

  bool update = false;

  bool edit = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      color: const Color.fromRGBO(244, 244, 244, 1),
      child: Column(
        children: [
          //COLUMN 1
          Expanded(
            child: Container(
              width: double.infinity,
              child: Row(
                children: [
                  //STORE DETAILS TEXT
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            height: 110,
                            //color: Colors.white,

                            child: Text(
                              'Store Details',
                              style: TextStyle(
                                  fontSize: 80,
                                  //fontWeight: FontWeight.w500,
                                  fontFamily: 'Koulen'),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 30, top: 0),
                            child: Text(
                              '(These details will appear on the receipt)',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(92, 94, 98, 1),
                                  //fontWeight: FontWeight.w500,
                                  fontFamily: 'Koulen'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //STORE DETAILS FORM
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      margin: const EdgeInsets.only(bottom: 0, top: 10),
                      child: Column(
                        children: [
                          // shop name
                          Container(
                            // height: height * 0.1,
                            width: width * 0.35,
                            margin: const EdgeInsets.only(bottom: 0, top: 0),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  //height: height * 0.022,
                                  //color: Colors.white,
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 0, top: 0, bottom: 0),
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Name',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(92, 94, 98, 1),
                                            fontSize: 15,
                                            fontFamily: 'Koulen',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: height * 0.048,
                                  width: double.infinity,
                                  //height: height * 0.04,
                                  //color: Colors.black,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 0, bottom: 0),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, top: 0, bottom: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors
                                              .grey, // Color of the shadow
                                          offset: Offset
                                              .zero, // Offset of the shadow
                                          blurRadius:
                                              6, // Spread or blur radius of the shadow
                                          spreadRadius:
                                              0, // How much the shadow should spread
                                        )
                                      ]),
                                  child: TextFormField(
                                    maxLines: 1,

                                    readOnly: true, // Prevent system keyboard
                                    showCursor: false,
                                    focusNode: _shopName,

                                    enabled: update,

                                    controller: _ctrlShopName,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Koulen',
                                        fontSize: 17),
                                    cursorColor: Colors.black,

                                    // enabled: !update,

                                    decoration: InputDecoration(
                                      // Wrap the TextFormField with GestureDetector to capture horizontal swipes

                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),

                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(0, 51, 154, 1),
                                            width: 2),
                                      ),

                                      labelStyle: TextStyle(
                                        fontFamily: 'Koulen',
                                        color: Colors.black,
                                        //fontWeight: FontWeight.bold
                                      ),
                                      //counterStyle: TextStyle(color: Colors.white, ),
                                      labelText: '',
                                    ),

                                    /* decoration: const InputDecoration(
                                                                                                    labelText: 'Product Name'),*/
                                    validator: (val) =>

                                        // ignore: prefer_is_empty
                                        (val!.length == 0
                                            ? 'This field is mandatory'
                                            : null),
                                    onSaved: (val) => {
                                      setState(() {
                                        //_inventory.productName = val;
                                        //_supply.productName = val;
                                      }),
                                    },
                                  ),
                                ),
                                Container(
                                  // height: height * 0.022,
                                  margin: const EdgeInsets.only(
                                      top: 0, left: 0, right: 0, bottom: 0),
                                  width: double.infinity,
                                  //height: height * 0.05,
                                  //color: Colors.black,
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: errorShopName,
                                          style: TextStyle(
                                            color: Color.fromRGBO(139, 0, 0, 1),
                                            fontSize: 13,
                                            fontFamily: 'Koulen',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // shop phone
                          Container(
                            // height: height * 0.1,
                            width: width * 0.35,
                            margin: const EdgeInsets.only(bottom: 0, top: 0),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  //height: height * 0.022,
                                  //color: Colors.white,
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 0, top: 0, bottom: 0),
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Phone Number',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(92, 94, 98, 1),
                                            fontSize: 15,
                                            fontFamily: 'Koulen',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: height * 0.048,
                                  width: double.infinity,
                                  //height: height * 0.04,
                                  //color: Colors.black,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 0, bottom: 0),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, top: 0, bottom: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors
                                              .grey, // Color of the shadow
                                          offset: Offset
                                              .zero, // Offset of the shadow
                                          blurRadius:
                                              6, // Spread or blur radius of the shadow
                                          spreadRadius:
                                              0, // How much the shadow should spread
                                        )
                                      ]),
                                  child: TextFormField(
                                    maxLines: 1,

                                    readOnly: true, // Prevent system keyboard
                                    showCursor: false,
                                    focusNode: _shopPhone,
                                    enabled: update,

                                    controller: _ctrlShopPhone,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Koulen',
                                        fontSize: 17),
                                    cursorColor: Colors.black,

                                    //enabled: !lock,

                                    decoration: InputDecoration(
                                      // Wrap the TextFormField with GestureDetector to capture horizontal swipes

                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),

                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(0, 51, 154, 1),
                                            width: 2),
                                      ),

                                      labelStyle: TextStyle(
                                        fontFamily: 'Koulen',
                                        color: Colors.black,
                                        //fontWeight: FontWeight.bold
                                      ),
                                      //counterStyle: TextStyle(color: Colors.white, ),
                                      labelText: '',
                                    ),

                                    /* decoration: const InputDecoration(
                                                                                                    labelText: 'Product Name'),*/
                                    validator: (val) =>

                                        // ignore: prefer_is_empty
                                        (val!.length == 0
                                            ? 'This field is mandatory'
                                            : null),
                                    onSaved: (val) => {
                                      setState(() {
                                        //_inventory.productName = val;
                                        //_supply.productName = val;
                                      }),
                                    },
                                  ),
                                ),
                                Container(
                                  // height: height * 0.022,
                                  margin: const EdgeInsets.only(
                                      top: 0, left: 0, right: 0, bottom: 0),
                                  width: double.infinity,
                                  //height: height * 0.05,
                                  //color: Colors.black,
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: errorShopPhone,
                                          style: TextStyle(
                                            color: Color.fromRGBO(139, 0, 0, 1),
                                            fontSize: 13,
                                            fontFamily: 'Koulen',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // shop address
                          Container(
                            // height: height * 0.1,
                            width: width * 0.35,
                            margin: const EdgeInsets.only(bottom: 0, top: 0),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  //height: height * 0.022,
                                  //color: Colors.white,
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 0, top: 0, bottom: 0),
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Address',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(92, 94, 98, 1),
                                            fontSize: 15,
                                            fontFamily: 'Koulen',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: height * 0.048,
                                  width: double.infinity,
                                  //height: height * 0.04,
                                  //color: Colors.black,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 0, bottom: 0),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, top: 0, bottom: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors
                                              .grey, // Color of the shadow
                                          offset: Offset
                                              .zero, // Offset of the shadow
                                          blurRadius:
                                              6, // Spread or blur radius of the shadow
                                          spreadRadius:
                                              0, // How much the shadow should spread
                                        )
                                      ]),
                                  child: TextFormField(
                                    maxLines: 1,
                                    enabled: update,

                                    readOnly: true, // Prevent system keyboard
                                    showCursor: false,
                                    focusNode: _shopAdd,

                                    controller: _ctrlShopAdd,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Koulen',
                                        fontSize: 17),
                                    cursorColor: Colors.black,

                                    //enabled: !lock,

                                    decoration: InputDecoration(
                                      // Wrap the TextFormField with GestureDetector to capture horizontal swipes

                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),

                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(0, 51, 154, 1),
                                            width: 2),
                                      ),

                                      labelStyle: TextStyle(
                                        fontFamily: 'Koulen',
                                        color: Colors.black,
                                        //fontWeight: FontWeight.bold
                                      ),
                                      //counterStyle: TextStyle(color: Colors.white, ),
                                      labelText: '',
                                    ),

                                    /* decoration: const InputDecoration(
                                                                                                    labelText: 'Product Name'),*/
                                    validator: (val) =>

                                        // ignore: prefer_is_empty
                                        (val!.length == 0
                                            ? 'This field is mandatory'
                                            : null),
                                    onSaved: (val) => {
                                      setState(() {
                                        //_inventory.productName = val;
                                        //_supply.productName = val;
                                      }),
                                    },
                                  ),
                                ),
                                Container(
                                  // height: height * 0.022,
                                  margin: const EdgeInsets.only(
                                      top: 0, left: 0, right: 0, bottom: 0),
                                  width: double.infinity,
                                  //height: height * 0.05,
                                  //color: Colors.black,
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: errorShopAdd,
                                          style: TextStyle(
                                            color: Color.fromRGBO(139, 0, 0, 1),
                                            fontSize: 13,
                                            fontFamily: 'Koulen',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // shop UPI ID
                          Container(
                            // height: height * 0.1,
                            width: width * 0.35,
                            margin: const EdgeInsets.only(bottom: 0, top: 0),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  //height: height * 0.022,
                                  //color: Colors.white,
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 0, top: 0, bottom: 0),
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'UPI ID',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(92, 94, 98, 1),
                                            fontSize: 15,
                                            fontFamily: 'Koulen',
                                          ),
                                        ),
                                        TextSpan(
                                          text: '  (for receiving payments)',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(92, 94, 98, 1),
                                            fontSize: 13,
                                            fontFamily: 'Koulen',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: height * 0.048,
                                  width: double.infinity,
                                  //height: height * 0.04,
                                  //color: Colors.black,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 0, bottom: 0),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, top: 0, bottom: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors
                                              .grey, // Color of the shadow
                                          offset: Offset
                                              .zero, // Offset of the shadow
                                          blurRadius:
                                              6, // Spread or blur radius of the shadow
                                          spreadRadius:
                                              0, // How much the shadow should spread
                                        )
                                      ]),
                                  child: TextFormField(
                                    enabled: update,
                                    maxLines: 1,

                                    readOnly: true, // Prevent system keyboard
                                    showCursor: false,
                                    focusNode: _shopWebsite,

                                    controller: _ctrlShopWebsite,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Koulen',
                                        fontSize: 17),
                                    cursorColor: Colors.black,

                                    //enabled: !lock,

                                    decoration: InputDecoration(
                                      // Wrap the TextFormField with GestureDetector to capture horizontal swipes

                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),

                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(0, 51, 154, 1),
                                            width: 2),
                                      ),

                                      labelStyle: TextStyle(
                                        fontFamily: 'Koulen',
                                        color: Colors.black,
                                        //fontWeight: FontWeight.bold
                                      ),
                                      //counterStyle: TextStyle(color: Colors.white, ),
                                      labelText: '',
                                    ),

                                    /* decoration: const InputDecoration(
                                                                                                    labelText: 'Product Name'),*/
                                    validator: (val) =>

                                        // ignore: prefer_is_empty
                                        (val!.length == 0
                                            ? 'This field is mandatory'
                                            : null),
                                    onSaved: (val) => {
                                      setState(() {
                                        //_inventory.productName = val;
                                        //_supply.productName = val;
                                      }),
                                    },
                                  ),
                                ),
                                Container(
                                  // height: height * 0.022,
                                  margin: const EdgeInsets.only(
                                      top: 0, left: 0, right: 0, bottom: 0),
                                  width: double.infinity,
                                  //height: height * 0.05,
                                  //color: Colors.black,
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: errorShopWebsite,
                                          style: TextStyle(
                                            color: Color.fromRGBO(139, 0, 0, 1),
                                            fontSize: 13,
                                            fontFamily: 'Koulen',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // button
                          Container(
                            height: height * 0.05,
                            width: width * 0.35,
                            margin: const EdgeInsets.only(bottom: 0, top: 20),
                            child: Row(
                              children: [
                                Expanded(child: Container()),
                                Container(
                                  width: width * 0.15,
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: update
                                          ? Colors.grey
                                          : Colors.white, // Color of the shadow
                                      offset:
                                          Offset.zero, // Offset of the shadow
                                      blurRadius:
                                          6, // Spread or blur radius of the shadow
                                      spreadRadius:
                                          0, // How much the shadow should spread
                                    )
                                  ]),
                                  child: TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            update
                                                ? Colors.black
                                                : Color.fromARGB(
                                                    255, 172, 171, 171),
                                          ),
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4)))),
                                      onPressed: () async {
                                        if (update) {
                                          if (_ctrlShopName.text.isEmpty ||
                                              errorShopName != '') {
                                            setState(() {
                                              if (_ctrlShopName.text.isEmpty) {
                                                errorShopName =
                                                    'This field is mandatory';
                                              } else {
                                                errorShopName = '';
                                              }
                                            });
                                          } else {
                                            _store.name =
                                                _ctrlShopName.text != ''
                                                    ? _ctrlShopName.text
                                                    : '';
                                            _store.phone =
                                                _ctrlShopPhone.text != ''
                                                    ? _ctrlShopPhone.text
                                                    : '';
                                            _store.address =
                                                _ctrlShopAdd.text != ''
                                                    ? _ctrlShopAdd.text
                                                    : '';
                                            _store.website =
                                                _ctrlShopWebsite.text != ''
                                                    ? _ctrlShopWebsite.text
                                                    : '';

                                            _store.code = _ctrlShopCode.text;

                                            await _dbHelperStore
                                                .updateStore(_store);

                                            _registerFirebase();
                                            _fetchStore();
                                            setState(() {
                                              update = false;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            update = true;
                                            //cont
                                            _controllerText.text =
                                                'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
                                          });
                                        }
                                      },
                                      child: Text(
                                          update == false ? 'Edit' : 'Update',
                                          style: TextStyle(
                                              fontFamily: 'Koulen',
                                              fontSize: 15,
                                              color: Colors.white))),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          //COLUMN 2 - KEYBOARD
          Container(
            width: double.infinity,
            height: height * 0.375,
            margin: const EdgeInsets.only(bottom: 0, right: 0),
            decoration: BoxDecoration(color: Colors.black, boxShadow: [
              BoxShadow(
                color: Colors.grey, // Color of the shadow
                offset: Offset.zero, // Offset of the shadow
                blurRadius: 6, // Spread or blur radius of the shadow
                spreadRadius: 0, // How much the shadow should spread
              )
            ]),
            child: VirtualKeyboard(
                textColor: Colors.white,
                textController: _controllerText,
                defaultLayouts: [VirtualKeyboardDefaultLayouts.English],
                type: VirtualKeyboardType.Alphanumeric,
                onKeyPress: (key) {
                  _onKeyPress(
                      key,
                      _shopName.hasFocus
                          ? _ctrlShopName
                          : _shopPhone.hasFocus
                              ? _ctrlShopPhone
                              : _upi.hasFocus
                                  ? _ctrlUpi
                                  : _shopAdd.hasFocus
                                      ? _ctrlShopAdd
                                      : _shopWebsite.hasFocus
                                          ? _ctrlShopWebsite
                                          : _none);
                }),
          )
        ],
      ),
    );
  }
}
